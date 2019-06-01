//
//  ViewController.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/29.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import UIKit
import AVKit

class GalleryViewController: UIViewController {
    
    var galleryView: GalleryView?
    var galleryController = GalleryController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let top = UIApplication.shared.statusBarFrame.size.height
        let bottom = CGFloat(34)
        galleryView = GalleryView(frame: CGRect(x: 0, y: top, width: self.view.bounds.width, height: self.view.bounds.height - top - bottom))
        self.view.addSubview(galleryView!)
        galleryView?.dataSource = self
        
        initBinding()
        galleryController.prepareGalleryInfo()
        
    }
    
    func initBinding() {
        
        galleryController.galleryViewViewModel.isLoading.addObserver { [weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showActivityIndicator()
                } else {
                    self?.hideActivityIndicator()
                }
            }
        }
        
        galleryController.galleryViewViewModel.alertViewViewModel.shouldShow.addObserver { [weak self] (shouldShow) in
            if shouldShow {
                let data = self?.galleryController.galleryViewViewModel.alertViewViewModel
                if let title = data?.alertTitle, let msg = data?.alertMsg {
                    DispatchQueue.main.async {
                        self?.presentAlert(title: title, msg: msg, handler: data?.defauleHandler)
                    }
                }
            }
        }
        
        galleryController.galleryViewViewModel.videoCellViewModels.addObserver { (viewModels) in
            DispatchQueue.main.async {
                self.galleryView?.reloadData()
            }
        }
        
        galleryController.galleryViewViewModel.photoCellViewModels.addObserver { (viewModels) in
            DispatchQueue.main.async {
                self.galleryView?.reloadData()
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func presentAlert(title:String, msg: String, handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertVC.addAction(okBtn)
        self.present(alertVC, animated: true, completion: nil)
    }
}


extension GalleryViewController: GalleryViewDataSource {
    
    func setup(videoCell: VideoCell, at index: Int, of galleryView: GalleryView) {
        videoCell.setup(with: self.galleryController.galleryViewViewModel.videoCellViewModels.value[index])
    }
    
    func setup(photoCell: PhotoCell, at index: Int, of galleryView: GalleryView) {
        photoCell.setup(with: self.galleryController.galleryViewViewModel.photoCellViewModels.value[index])
    }
    
    func numberOfWorks(galleryView: GalleryView) -> Int {
        return self.galleryController.galleryViewViewModel.videoCellViewModels.value.count
    }
    
}
