//
//  ImageDownload.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/31.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit

class ImageLoad: Operation {
    
    let work: Work
    
    init(work: Work) {
        self.work = work
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        let cacheData = DataCacher.read(url: work.imageUrl)
        
        if let data = cacheData {
            finish(with: data)
        } else {
            guard let data = try? Data(contentsOf: URL(string: work.imageUrl)!) else {
                work.imageState = .failed
                return
            }
            finish(with: data)
            let _ = DataCacher.save(data: data, for: work.imageUrl)
        }
    }
    
    func finish(with data: Data?) {
        if let data = data {
            if !data.isEmpty {
                work.imageState = ImageState.ready
                work.image = UIImage(data: data)
            } else {
                work.imageState = ImageState.failed
                work.image = UIImage(named: "image_failed")
            }
        } else {
            work.imageState = ImageState.failed
            work.image = UIImage(named: "image_failed")
        }
        
    }
}
