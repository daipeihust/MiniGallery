//
//  VideoCellViewModel.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class VideoCellViewModel {
    
    var video: AsyncVideo
    var isLoading = Observable(true)
    
    init(url: String) {
        video = AsyncVideo(url: url)
        video.loadingCompletion = { [weak self] in
            self?.isLoading.value = false
        }
    }
    
    func startLoading() {
        video.startLoading()
    }
    
}
