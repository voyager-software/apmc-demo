//
//  AccountService.swift
//  APMCDemoCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

public final class VideoService: MockyService, @unchecked Sendable {
    // MARK: Lifecycle

    override public init() {}

    // MARK: Public

    public func getVideos() async throws -> [Video] {
        print("Loading videos")
        return try await self.req(MockyEndpoint.getVideos, of: [Video].self)
    }
}
