//
//  Data.swift
//  APMCDemoCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

public extension Data {
    var utf8String: String? { String(data: self, encoding: .utf8) }
}
