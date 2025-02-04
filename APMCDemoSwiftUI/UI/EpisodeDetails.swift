//
//  EpisodeDetails.swift
//  APMCDemoSwiftUI
//
//  Created by Gabor Shaio on 2025-02-03.
//

import SwiftUI
import AVKit
import APMCCore

struct EpisodeDetails: View {
    let episode: EpisodeViewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 12) {
                Text(episode.title)
                    .font(.title)

                if episode.hasDescriptipn {
                    Text(episode.description ?? "")
                        .font(.body)
                }

                if let url = episode.url {
                    PlayerView(url: url)
                        .aspectRatio(16 / 9, contentMode: .fit)
                }
                else {
                    PlaceholderView()
                        .aspectRatio(16 / 9, contentMode: .fit)
                }

                Text(episode.durationText)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

struct PlayerView: View {
    // MARK: Lifecycle

    init(url: URL) {
        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            VideoPlayer(player: self.player)
                .cornerRadius(8)
            ProgressView()
                .tint(.white)
                .scaleEffect(2)
                .hide(if: !self.showingSpinner)
        }
        .onAppear {
            self.playerManager.addObservers(player: self.player)
        }
        .onDisappear {
            self.playerManager.removeObservers()
        }
        .onReceive(self.playerManager.onPaybackReady) {
            self.player.play()
        }
        .onReceive(self.playerManager.onPaybackStarted) {
            self.showingSpinner = false
        }
        .onReceive(self.playerManager.onPaybackFailed) { message in
            self.showingSpinner = false
            self.playerManager.removeObservers()
            if let message {
                self.showingAlert = true
                self.alertText = message
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Video Playback Failed"),
                message: Text(self.alertText)
            )
        }
    }

    // MARK: Private

    @State private var showingSpinner = true
    @State private var showingAlert = false
    @State private var alertText = ""

    private let player: AVPlayer
    private let playerManager = PlayerManager()
}

struct PlaceholderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemGray6))
            Image(systemName: "video")
                .imageScale(.large)
                .foregroundColor(.accent)
        }
    }
}
