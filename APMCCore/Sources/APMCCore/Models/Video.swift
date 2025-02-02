//
//  Video.swift
//  APMCDemoCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

public struct Video: Decodable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let videoUrl: String
    public let duration: Int
}
