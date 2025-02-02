//
//  PocketService.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

public class MockyService: ApiClient, @unchecked Sendable {
    // MARK: Internal

    var urlSession: URLSession { Self.sharedSession }

    func createUrlRequest(_ endpoint: Endpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.url) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        request.allHTTPHeaderFields = [
            HttpHeader.acceptEncoding: ["br", "gzip", "deflate"].qualityEncoded(),
            HttpHeader.contentType: "application/json",
        ]

        return request
    }

    // MARK: Private

    private static let delegateQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        return queue
    }()

    private static let sharedSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120
        config.waitsForConnectivity = true
        config.urlCache = nil
        config.httpMaximumConnectionsPerHost = 32
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: MockyService.delegateQueue)
        return session
    }()
}

private extension Collection<String> {
    func qualityEncoded() -> String {
        enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}
