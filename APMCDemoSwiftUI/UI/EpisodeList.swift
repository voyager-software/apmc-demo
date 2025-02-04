//
//  EpisodeList.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-03.
//

import SwiftUI
import APMCCore

struct EpisodeList: View {
    // MARK: Internal

    var body: some View {
        NavigationView {
            List(self.viewModel.episodes) { episode in
                NavigationLink(destination: EpisodeDetails(episode: episode)) {
                    EpisodeRow(episode: episode)
                }
            }
            .navigationTitle("Episodes")
        }
        .task {
            do {
                try await viewModel.load()
            }
            catch {
                self.showingAlert = true
                self.alertText = error.localizedDescription
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Unable to load the episodes"),
                message: Text(self.alertText)
            )
        }
    }

    // MARK: Private

    @StateObject private var viewModel = EpisodeListViewModel()
    @State private var alertText = ""
    @State private var showingAlert = false
}

private struct EpisodeRow: View {
    let episode: EpisodeViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "video")
                .imageScale(.large)
                .foregroundColor(.accent)

            VStack(alignment: .leading, spacing: 6) {
                Text(episode.title)
                    .font(.headline)

                Text(episode.durationText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    EpisodeList()
}
