//
//  GalleryService.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class GalleryService {
    
    static let shared = GalleryService()
    
    let galleryApi = "http://private-04a55-videoplayer1.apiary-mock.com/pictures"
    
    func fetchGallerys(completion: @escaping ([GalleryResModel]?, Error?)->Void) {
        
        var galleryRequest = URLRequest(url: URL(string: galleryApi)!)
        galleryRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: galleryRequest) { (data, res, err) in
            
            guard err == nil, let data = data else {
                completion(nil, err)
                return
            }
            do {
                guard let items: [Dictionary<String, Any>] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Dictionary<String, Any>] else { return }
                
                var galleryResArray = [GalleryResModel]()
                
                for item in items {
                    let galleryRes = GalleryResModel(id: item["id"] as! Int, imageUrl: item["imageUrl"] as! String, videoUrl: item["videoUrl"] as! String)
                    galleryResArray.append(galleryRes)
                }
                completion(galleryResArray, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
