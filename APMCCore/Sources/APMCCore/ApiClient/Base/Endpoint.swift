//
//  Endpoint.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//


import Foundation

protocol Endpoint: CustomStringConvertible, Sendable {
    var method: HttpMethod { get }
    var baseUrl: String { get }
    var urlFormat: String { get }
    var params: [CVarArg]? { get }

    init(_ method: HttpMethod, _ format: String, params: [CVarArg]?)
    func with(_ params: CVarArg...) -> Endpoint
}

extension Endpoint {
    func with(_ params: CVarArg...) -> Endpoint {
        Self(self.method, self.urlFormat, params: params)
    }

    var url: String {
        if let params = self.params {
            self.baseUrl + String(format: self.urlFormat, arguments: params)
        }
        else {
            self.baseUrl + self.urlFormat
        }
    }

    public var description: String {
        "\(self.method.rawValue): \(self.url)"
    }
}
