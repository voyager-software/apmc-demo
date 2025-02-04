//
//  PlayerManager.swift
//  APMCCore
//
//  Created by Gabor Shaio on 2025-02-02.
//

import AVFoundation
import Combine

public final class PlayerManager: @unchecked Sendable {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public let onPaybackReady = PassthroughSubject<Void, Never>()
    public let onPaybackStarted = PassthroughSubject<Void, Never>()
    public let onPaybackPaused = PassthroughSubject<Void, Never>()
    public let onPaybackFailed = PassthroughSubject<String?, Never>()

    public func addObservers(player: AVPlayer) {
        self.statusObserver = player.currentItem?.observe(\.status) { [weak self] item, _ in
            guard let self else { return }

            if let error = item.error as NSError? {
                let message = error.localizedFailureReason ?? error.localizedDescription
                print(message)
                self.onPaybackFailed.send(message)
                return
            }

            switch item.status {
            case .failed:
                print("Status: Failed")
                self.onPaybackFailed.send(nil)
            case .readyToPlay:
                print("Status: Ready to Play")
                self.onPaybackReady.send(())
            case .unknown:
                print("Status: Unknown")
            @unknown default:
                print("Status: Unknown")
            }
        }

        self.rateObserver = player.observe(\.rate, options: [.old, .new]) { [weak self] _, change in
            guard
                let self,
                let oldRate = change.oldValue,
                let newRate = change.newValue
            else { return }

            if oldRate != 0, newRate == 0 {
                print("Status: Paused")
                self.onPaybackPaused.send(())
            }
            else if oldRate == 0, newRate != 0 {
                print("Status: Playing")
                self.onPaybackStarted.send(())
            }

            print("Player observers added")
        }
    }

    public func removeObservers() {
        self.statusObserver?.invalidate()
        self.statusObserver = nil
        self.rateObserver?.invalidate()
        self.rateObserver = nil
        print("Player observers removed")
    }

    // MARK: Private

    private var statusObserver: NSKeyValueObservation?
    private var rateObserver: NSKeyValueObservation?
}
