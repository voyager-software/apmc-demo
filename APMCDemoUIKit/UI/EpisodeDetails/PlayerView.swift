//
//  PlayerView.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation
import AVKit

final class PlayerView: UIView {
    override public static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    public var player: AVPlayer? {
        get { self.playerLayer.player }
        set { self.playerLayer.player = newValue }
    }

    public var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}
