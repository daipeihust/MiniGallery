//
//  VideoCell.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/29.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoCell: UIView {
    
    let player = AVPlayer(playerItem: nil)
    let playerLayer = AVPlayerLayer(player: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replaceCurrentItem(with playerItem: AVPlayerItem?) {
        player.replaceCurrentItem(with: playerItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func play() {
        self.player.play()
    }
    
    func stop() {
        self.player.pause()
    }
    
    @objc func playToEnd(notification: NSNotification) {
        guard let playerItem = notification.object else {
            return
        }
        if playerItem as? AVPlayerItem == self.player.currentItem {
            player.seek(to: CMTime(value: 0, timescale: 1))
            player.play()
        }
    }
    
}
