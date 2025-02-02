//
//  ApiClient.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

protocol ApiClient: Sendable {
    var urlSession: URLSession { get }
    func createUrlRequest(_ endpoint: Endpoint) -> URLRequest?
}

// MARK: - Requests

extension ApiClient {
    func req(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            #if DEBUG
                let start = Date.now
            #endif

            let (data, response) = try await self.urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw InvalidResponse(request: request)
            }

            if !HttpStatus.success.contains(httpResponse.statusCode) {
                throw HttpError(request: request, response: httpResponse, responseData: data)
            }

            #if DEBUG
                let duration = Date.now.timeIntervalSince(start)
                self.trace(request: request, contentLenght: data.count, duration: duration)
            #endif

            return (data, httpResponse)
        }
        catch let error as InvalidResponse {
            self.logError(error.localizedDescription, request: request, responseData: nil)
            throw error
        }
        catch let error as HttpError {
            self.logError(error.localizedDescription, request: request, responseData: error.responseData)
            throw error
        }
        catch {
            let error = error as NSError

            let msg = error.code == 1
                ? error.localizedDescription
                : "\(error.localizedDescription) (\(error.code)) \(request.logDescription)"

            self.logError(msg, request: request, responseData: nil)

            throw error
        }
    }

    @discardableResult
    func req(
        _ endpoint: Endpoint,
        bodyData: Data? = nil
    )
        async throws -> (Data, HTTPURLResponse)
    {
        guard var request = self.createUrlRequest(endpoint) else {
            throw InvalidURL(urlString: endpoint.url)
        }

        if let data = bodyData {
            request.httpBody = data
            request.allHTTPHeaderFields?[HttpHeader.contentLength] = data.count.description
        }

        return try await self.req(request)
    }

    @discardableResult
    func req(
        _ endpoint: Endpoint,
        body: some Encodable = Empty.value
    )
        async throws -> (Data, HTTPURLResponse)
    {
        let bodyData = body is Empty
            ? nil
            : try ApiClientUtils.encoder.encode(body)

        return try await self.req(endpoint, bodyData: bodyData)
    }

    @discardableResult
    func req<TValue: Decodable>(
        _ endpoint: Endpoint,
        body: some Encodable = Empty.value,
        of _: TValue.Type = TValue.self
    )
        async throws -> (TValue, HTTPURLResponse)
    {
        let bodyData = body is Empty
            ? nil
            : try ApiClientUtils.encoder.encode(body)

        let (data, response) = try await self.req(endpoint, bodyData: bodyData)

        let value = try self.decode(TValue.self, from: data)

        return (value, response)
    }
}

// MARK: - Requests with only codable result

extension ApiClient {
    func req<TValue: Decodable & Sendable>(
        _ endpoint: Endpoint,
        body: some Encodable = Empty.value,
        of _: TValue.Type = TValue.self
    )
        async throws -> TValue
    {
        let bodyData = body is Empty
            ? nil
            : try ApiClientUtils.encoder.encode(body)

        let (data, _) = try await self.req(endpoint, bodyData: bodyData)

        return try self.decode(TValue.self, from: data)
    }
}

// MARK: - Logging

private extension ApiClient {
    func logError(_ message: String, request: URLRequest, responseData: Data?) {
        var info: [String: String] = [:]

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            info["headers"] = headers
                .map { "\"\($0)\": \"\($1)\";" }
                .joined(separator: " ")
        }

        if let responseData, !responseData.isEmpty, let string = responseData.utf8String {
            info["response-body"] = string
        }

        print(message)
        print(info)
    }

    func trace(request: URLRequest, contentLenght: Int, duration: TimeInterval) {
        let durationText = String(format: "%.3fs", duration)

        let size = ByteCountFormatter.string(fromByteCount: Int64(contentLenght), countStyle: .binary)

        print("\(request.logDescription) -> \(size) in \(durationText)")
    }
}

// MARK: - JSON decoding/encoding

extension ApiClient {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try ApiClientUtils.decoder.decode(type, from: data)
        }
        catch let DecodingError.keyNotFound(key, context) {
            self.logDecodingError(type: type, data: data, context: context)
            throw DecodingError.keyNotFound(key, context)
        }
        catch let DecodingError.typeMismatch(t, context) {
            self.logDecodingError(type: type, data: data, context: context)
            throw DecodingError.typeMismatch(t, context)
        }
        catch let DecodingError.valueNotFound(t, context) {
            self.logDecodingError(type: type, data: data, context: context)
            throw DecodingError.valueNotFound(t, context)
        }
        catch let DecodingError.dataCorrupted(context) {
            self.logDecodingError(type: type, data: data, context: context)
            throw DecodingError.dataCorrupted(context)
        }
        catch {
            self.logDecodingError(type: type, data: data, error: error)
            throw error
        }
    }

    private func logDecodingError(type: (some Any).Type, data: Data, context: DecodingError.Context? = nil, error: Error? = nil) {
        let title = [
            "[\(type)]",
            context?.debugDescription,
            error?.localizedDescription,
        ]
        .compactMap { $0 }
        .joined(separator: " ")

        let paths = context?.codingPath
            .map(\.stringValue)
            .joined(separator: " | ")

        let msg = [
            title,
            (paths ?? "").isEmpty ? nil : paths,
            data.utf8String,
        ]
        .compactMap { $0 }
        .joined(separator: "\n")

        print(msg)
    }

    func encode(value: some Encodable) -> Data? {
        do {
            return try ApiClientUtils.encoder.encode(value)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
