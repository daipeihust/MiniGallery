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
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    weak var viewModel: VideoCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        activityIndicator.frame = self.bounds
        self.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        
    }
    
    func showLoadView(shouldShow: Bool) {
        activityIndicator.isHidden = !shouldShow
        if shouldShow {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replaceCurrentItem(with playerItem: AVPlayerItem?) {
        player.replaceCurrentItem(with: playerItem)
    }
    
    func setup(with viewModel: VideoCellViewModel) {
        
        viewModel.startLoading()
        
        self.replaceCurrentItem(with: viewModel.video.playerItem)
        
        viewModel.isLoading.addObserver {[weak self] (isLoading) in
            self?.showLoadView(shouldShow: isLoading)
            if !isLoading {
                DispatchQueue.main.async {
                    self?.replaceCurrentItem(with: viewModel.video.playerItem)
                }
            }
        }
        self.viewModel = viewModel
    }
    
    func prepareForReuse() {
        if let viewModel = self.viewModel {
            viewModel.isLoading.removeObserver()
        }
        self.replaceCurrentItem(with: nil)
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
