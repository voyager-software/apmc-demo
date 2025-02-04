//
//  EpisodeListViewModel.swift
//  APMCDemoCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

import SwiftUI

public final class EpisodeListViewModel: ObservableObject, @unchecked Sendable {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    @Published public private(set) var episodes: [EpisodeViewModel] = []

    public func load() async throws {
        let videos = try await self.svc.getVideos()
        self.episodes = videos.map(EpisodeViewModel.init)
    }

    // MARK: Private

    private let svc = VideoService()
}
