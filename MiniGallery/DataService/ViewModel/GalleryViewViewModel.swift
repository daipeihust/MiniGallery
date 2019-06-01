//
//  GalleryViewViewModel.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class GalleryViewViewModel {
    
    var isLoading = Observable(true)
    var alertViewViewModel = AlertViewViewModel()
    var photoCellViewModels = Observable([PhotoCellViewModel]())
    var videoCellViewModels = Observable([VideoCellViewModel]())
    
    init() {
        alertViewViewModel.defauleHandler = { [weak alertViewViewModel] alertAction in
            alertViewViewModel?.shouldShow.value = false
        }
    }
    
}
