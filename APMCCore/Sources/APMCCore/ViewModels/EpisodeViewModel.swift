//
//  EpisodeViewModel.swift
//  APMCDemoCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation

public struct EpisodeViewModel: Identifiable, Sendable {
    // MARK: Lifecycle

    init(video: Video) {
        self.video = video
    }

    // MARK: Public

    public var id: String {
        video.id
    }

    public var title: String {
        video.title
    }

    public var description: String? {
        video.description
    }

    public var hasDescriptipn: Bool {
        if let description = video.description {
            return !description.isEmpty
        }
        return false
    }

    public var url: URL? {
        URL(string: video.videoUrl)
    }

    public var durationText: String {
        let duration = Duration.seconds(self.video.duration)
        return duration.formatted(
            .time(pattern: .minuteSecond)
        )
    }

    // MARK: Private

    private let video: Video
}
