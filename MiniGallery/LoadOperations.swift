//
//  DownloadOperations.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/31.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class LoadOperations {
    
    lazy var imageLoadRecord: [Int : Operation] = [:]
    lazy var imageLoadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        queue.name = "image load queue"
        return queue
    }()
    
    lazy var videoLoadRecord: [Int : Operation] = [:]
    lazy var videoLoadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "video load queue"
        return queue
    }()
    
}
