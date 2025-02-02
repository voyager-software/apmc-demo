//
//  ApiClientUtils.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

struct Empty: Codable, Sendable {
    public static let value = Empty()
}

enum HttpStatus {
    static let info = 100 ... 199
    static let success = 200 ... 299
    static let redirect = 300 ... 399
    static let clientError = 400 ... 499
    static let serverError = 500 ... 599
}

enum HttpHeader {
    static let accept = "Accept"
    static let acceptLanguage = "Accept-Language"
    static let authorization = "Authorization"
    static let acceptEncoding = "Accept-Encoding"
    static let contentType = "Content-Type"
    static let userAgent = "User-Agent"
    static let contentLength = "Content-Length"
}

struct HttpMethod: RawRepresentable, Equatable, Hashable {
    // MARK: Lifecycle

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Internal

    static let connect = HttpMethod(rawValue: "CONNECT")
    static let delete = HttpMethod(rawValue: "DELETE")
    static let get = HttpMethod(rawValue: "GET")
    static let head = HttpMethod(rawValue: "HEAD")
    static let options = HttpMethod(rawValue: "OPTIONS")
    static let patch = HttpMethod(rawValue: "PATCH")
    static let post = HttpMethod(rawValue: "POST")
    static let put = HttpMethod(rawValue: "PUT")
    static let query = HttpMethod(rawValue: "QUERY")
    static let trace = HttpMethod(rawValue: "TRACE")

    let rawValue: String
}

struct ApiClientUtils {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let urlErrorCodesAsInfo: Set<Int> = [
        NSURLErrorNetworkConnectionLost,
        NSURLErrorNotConnectedToInternet,
    ]

    static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .custom(Self.dateDecoderStrategy)
        return d
    }()

    static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    // MARK: Private

    private static func dateDecoderStrategy(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .iso8601)

        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: string) {
            return date
        }

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: string) {
            return date
        }

        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: string) {
            return date
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(string)")
    }
}

extension URLRequest {
    var logDescription: String {
        [self.httpMethod, self.url?.absoluteString, self.httpBodyText]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    var httpBodyText: String? {
        if let data = self.httpBody, let text = data.utf8String {
            return text
        }
        return nil
    }
}
