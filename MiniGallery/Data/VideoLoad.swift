//
//  VideoLoad.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/31.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import AVKit

class VideoLoad: Operation {
    
    let work: Work
    
    init(work: Work) {
        self.work = work
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        if DataCacher.exist(url: work.videoUrl) {
            let cachedUrl = DataCacher.cacheUrlFromUrl(url: work.videoUrl)
            work.cachedVideoUrl = cachedUrl
            work.video = AVPlayerItem(url: cachedUrl!)
            work.videoState = .cached
            return
        }
        
        guard let data = try? Data(contentsOf: URL(string: work.videoUrl)!) else {
            return
        }
        
        
        if !data.isEmpty, let cachedUrl = DataCacher.save(data: data, for: work.videoUrl) {
            work.cachedVideoUrl = cachedUrl
            work.video = AVPlayerItem(url: cachedUrl)
            work.videoState = .cached
        } else {
            if let url = URL(string: work.videoUrl) {
                work.video = AVPlayerItem(url: url)
            }
        }
        
    }
    
}
