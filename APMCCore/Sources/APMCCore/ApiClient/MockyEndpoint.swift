//
//  MockyEndpoint.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

struct MockyEndpoint: Endpoint, @unchecked Sendable {
    // MARK: Lifecycle

    init(_ method: HttpMethod, _ format: String, params: [CVarArg]? = nil) {
        self.method = method
        self.urlFormat = format
        self.params = params
    }

    // MARK: Internal

    static let getVideos = MockyEndpoint(.get, "v3/8419df8e-0160-4a35-a1e6-0237a527c566")

    let baseUrl: String = "https://run.mocky.io/"

    let method: HttpMethod
    let urlFormat: String
    let params: [CVarArg]?
}
