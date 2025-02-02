//
//  Errors.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

struct HttpError: LocalizedError, Sendable {
    // MARK: Lifecycle

    init(request: URLRequest, response: HTTPURLResponse, responseData: Data) {
        self.statusCode = response.statusCode
        self.request = request
        self.response = response
        self.responseData = responseData
    }

    // MARK: Internal

    let statusCode: Int
    let request: URLRequest
    let response: HTTPURLResponse
    let responseData: Data

    var errorDescription: String? {
        "HTTP \(self.statusCode). \(self.request.logDescription)"
    }
}

struct InvalidResponse: LocalizedError, Sendable {
    let request: URLRequest

    var errorDescription: String? {
        "Unexpected URLResponse type received. \(self.request.logDescription)"
    }
}

struct InvalidURL: LocalizedError, Sendable {
    let urlString: String

    var errorDescription: String? { "InvalidURL: \(self.urlString)" }
}

struct AppError: LocalizedError, Sendable {
    // MARK: Lifecycle

    init(_ message: String) {
        self.message = message
    }

    // MARK: Public

    let message: String

    var errorDescription: String? { self.message }
}
