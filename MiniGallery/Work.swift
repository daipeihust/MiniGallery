//
//  Work.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/29.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum ImageState {
    case unready
    case ready
    case failed
}

enum VideoState {
    case uncached
    case cached
}

class Work {
    let id: Int
    let imageUrl: String
    let videoUrl: String
    var cachedVideoUrl: URL?
    var video: AVPlayerItem?
    var image: UIImage? = UIImage(named: "image_placeholder")
    var imageState: ImageState = .unready
    var videoState: VideoState = .uncached
    
    init(_ id: Int, _ imageUrl: String, _ videoUrl: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
    }
}
