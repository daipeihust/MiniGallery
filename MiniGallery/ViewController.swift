//
//  ViewController.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/29.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, GalleryViewDataSource {
    
    let api = "http://private-04a55-videoplayer1.apiary-mock.com/pictures"
    
    var galleryView: GalleryView?
    let loadOperations = LoadOperations()
    
    var works:[Work] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryView = GalleryView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        self.view.addSubview(galleryView!)
        galleryView?.dataSource = self
        
        fetchGalleryInfo()
        
    }
    
    func fetchGalleryInfo() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: URL(string: api)!) { (data, res, err) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard err == nil, let data = data else {
                DispatchQueue.main.async {
                    self.presentAlert(msg: err?.localizedDescription ?? "network error!")
                }
                return
            }
            do {
                guard let array: [Dictionary<String, Any>] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Dictionary<String, Any>] else { return }
                for item in array {
                    let work = Work(item["id"] as! Int, item["imageUrl"] as! String, item["videoUrl"] as! String)
                    self.works.append(work)
                }
                DispatchQueue.main.async {
                    self.galleryView?.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(msg: error.localizedDescription)
                }
            }
            }.resume()
        
    }
    
    func presentAlert(msg: String) {
        let alertVC = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okBtn)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func image(at index: Int, of galleryView: GalleryView) -> UIImage {
        
        let work = works[index]
        if work.imageState == .unready &&  loadOperations.imageLoadRecord[index] == nil {
            let imageDownload = ImageLoad(work: work)
            loadOperations.imageLoadRecord[index] = imageDownload
            loadOperations.imageLoadQueue.addOperation(imageDownload)
            
            imageDownload.completionBlock = {
                self.loadOperations.imageLoadRecord.removeValue(forKey: index)
                DispatchQueue.main.async {
                    galleryView.reloadImage(at: index)
                }
            }
        }
        
        
        
        return work.image!
    }
    
    
    func numberOfWorks(galleryView: GalleryView) -> Int {
        return works.count
    }
    
    func playerItem(at index: Int, of galleryView: GalleryView) -> AVPlayerItem? {
        
        let work = works[index]
        
        if work.videoState == .uncached && loadOperations.videoLoadRecord[index] == nil {
            let videoLoad = VideoLoad(work: work)
            loadOperations.videoLoadRecord[index] = videoLoad
            loadOperations.videoLoadQueue.addOperation(videoLoad)
            
            videoLoad.completionBlock = {
                self.loadOperations.imageLoadRecord.removeValue(forKey: index)
                DispatchQueue.main.async {
                    galleryView.reloadVideo(at: index)
                }
            }
            
        }
        
        return work.video
    }

}

