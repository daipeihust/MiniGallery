//
//  DPImage.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit

enum AsyncImageState {
    case initial
    case loading
    case ready
    case failed
    case invalid
}

class AsyncImage {
    
    static let downloadRecord = [String: Any]()
    
    var image: UIImage?
    var url: URL?
    var loadingState: AsyncImageState = .initial
    var loadingCompletion: (()->Void)?
    
    
    init(url: String, placeholder: UIImage) {
        image = placeholder
        self.url = URL(string: url)
        if let cachedImage = readCache() {
            image = cachedImage
            loadingState = .ready
        }
    }
    
    func startLoading() {
        guard self.loadingState != .loading || self.loadingState != .invalid else {
            return
        }
        
        if loadingState == .ready {
            self.loadingCompletion?()
        } else {
            if let url = self.url {
                self.loadingState = .loading
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                    guard let data = data, err == nil else {
                        self.loadingState = .failed
                        return
                    }
                    if let image = UIImage(data: data) {
                        self.image = image
                        self.loadingState = .ready
                        self.cacheImageData(data)
                    } else {
                        self.loadingState = .invalid
                    }
                    self.loadingCompletion?()
                }.resume()
            } else {
                self.loadingState = .invalid
            }
        }
    }
    
    func readCache() -> UIImage? {
        if let url = self.url {
            if let data = DataCacher.read(url: url) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    func cacheImageData(_ data: Data) {
        if let url = self.url {
            let _ = DataCacher.save(data: data, for: url)
        }
    }
    
    func cacheKey() -> String? {
        return self.url?.absoluteString.md5
    }
    
}
