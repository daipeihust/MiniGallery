//
//  PhotoCellViewModel.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit

class PhotoCellViewModel {
    
    var photo: AsyncImage
    var isLoading = Observable(true)
    
    init(url: String) {
        photo = AsyncImage(url: url, placeholder: UIImage(named: "image_placeholder")!)
        photo.loadingCompletion = { [weak self] in
            self?.isLoading.value = false
        }
    }
    
    func startLoading () {
        photo.startLoading()
    }
    
}
