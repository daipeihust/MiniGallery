//
//  GalleryController.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class GalleryController {
    
    let cacheKey = "galleryItems"
    
    var galleryViewViewModel = GalleryViewViewModel()
    
    func prepareGalleryInfo() {
        
        galleryViewViewModel.isLoading.value = true
        
        if let cacheModels = readCache() {
            galleryViewViewModel.isLoading.value = false
            buildViewModels(models: cacheModels)
            return
        }
        
        GalleryService.shared.fetchGallerys { (resModels, error) in
            
            self.galleryViewViewModel.isLoading.value = false
            
            guard let resModels = resModels, error == nil else {
                self.galleryViewViewModel.alertViewViewModel.alertTitle = "Error"
                self.galleryViewViewModel.alertViewViewModel.alertMsg = error?.localizedDescription ?? "Unknow error"
                self.galleryViewViewModel.alertViewViewModel.shouldShow.value = true
                return
            }
            
            self.buildViewModels(models: resModels)
            
            self.saveToCache(resModels: resModels)
        }
    }
    
    private func buildViewModels(models: [GalleryResModel]) {
        var tmpPhotoModels = [PhotoCellViewModel]()
        var tmpVideoModels = [VideoCellViewModel]()
        
        for item in models {
            let photoModel = PhotoCellViewModel(url: item.imageUrl)
            let videoModel = VideoCellViewModel(url: item.videoUrl)
            tmpPhotoModels.append(photoModel)
            tmpVideoModels.append(videoModel)
        }
        galleryViewViewModel.photoCellViewModels.value = tmpPhotoModels
        galleryViewViewModel.videoCellViewModels.value = tmpVideoModels
    }
    
    func readCache() -> [GalleryResModel]? {
        if let data = DataCacher.read(key: cacheKey) {
            return try? JSONDecoder().decode([GalleryResModel].self, from: data)
        }
        return nil
    }
    
    func saveToCache(resModels: [GalleryResModel]) {
        if let data = try? JSONEncoder().encode(resModels) {
            DataCacher.save(data: data, for: cacheKey)
        }
    }
    
}
