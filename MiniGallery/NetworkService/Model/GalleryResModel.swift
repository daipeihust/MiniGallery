//
//  GalleryResModel.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class GalleryResModel: Codable {
    let id: Int
    let imageUrl: String
    let videoUrl: String
    init(id: Int, imageUrl: String, videoUrl: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
    }
}
