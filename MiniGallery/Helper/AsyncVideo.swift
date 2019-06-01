//
//  DPVideo.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import AVKit

enum AsyncVideoState {
    case initial
    case loading
    case cached
    case online
}

class AsyncVideo {
    
    var playerItem: AVPlayerItem?
    var url: URL?
    var loadingCompletion: (()->Void)?
    var loadingState: AsyncVideoState = .initial
    
    init(url: String) {
        self.url = URL(string: url)
        if let cacheItem = readCache() {
            playerItem = cacheItem
            loadingState = .cached
        }
    }
    
    func startLoading() {
        guard loadingState != .loading && loadingState != .online else {
            return
        }
        
        if loadingState == .cached {
            loadingCompletion?()
        } else {
            if let url = self.url {
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                    if err == nil, let data = data {
                        if !data.isEmpty, let cacheUrl = self.saveVideoData(data) {
                            self.playerItem = AVPlayerItem(url: cacheUrl)
                            self.loadingState = .cached
                        }
                    } else {
                        self.playerItem = AVPlayerItem(url: url)
                        self.loadingState = .online
                    }
                    self.loadingCompletion?()
                }
            }
        }
    }
    
    func readCache() -> AVPlayerItem? {
        if let url = self.url {
            if let cacheUrl = DataCacher.cacheUrlFromUrl(url: url) {
                return AVPlayerItem(url: cacheUrl)
            }
        }
        return nil
    }
    
    func saveVideoData(_ data: Data) -> URL? {
        if let url = self.url {
            return DataCacher.save(data: data, for: url)
        }
        return nil
    }
    
}
