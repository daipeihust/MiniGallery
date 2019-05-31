//
//  GalleryView.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/29.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit
import AVKit

protocol GalleryViewDataSource: NSObjectProtocol {
    func numberOfWorks(galleryView: GalleryView) -> Int
    
    func image(at index: Int, of galleryView: GalleryView) -> UIImage
    
    func playerItem(at index: Int, of galleryView: GalleryView) -> AVPlayerItem?
}


class GalleryView: UIView {
    
    var focus = 0
    
    var videoContainers: [VideoCell] = []
    var imageContainers: [UIImageView] = []
    
    var imageWidth: Double = 0
    var imageHeight: Double = 0
    
    var leftSwipe: UISwipeGestureRecognizer!
    var rightSwipe: UISwipeGestureRecognizer!
    
    weak open var dataSource: GalleryViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageWidth = Double(self.bounds.width) / 6
        imageHeight = Double(self.bounds.height) / 4
        self.commonInit()
        configureVideoContainer()
        configureImageContainer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.reloadVideoData()
        self.reloadImageData()
    }
    
    private func commonInit() -> Void {
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipe.direction = .left
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipe.direction = .right
        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
    }
    
    @objc private func handleLeftSwipe() {
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else {
            return
        }
        if focus + 1 < count {
            videoCellDidSwipe(left: true)
            imageCellDidSwipe(left: true)
            focus = focus + 1
        }
        
    }
    
    @objc private func handleRightSwipe() {
        if focus - 1 >= 0 {
            videoCellDidSwipe(left: false)
            imageCellDidSwipe(left: false)
            focus = focus - 1
        }
    }
    
    private func beforeAnimation() {
        leftSwipe.isEnabled = false
        rightSwipe.isEnabled = false
        
    }
    
    private func afterAnimation() {
        self.leftSwipe.isEnabled = true
        self.rightSwipe.isEnabled = true
    }
    
}


// video part
extension GalleryView {
    
    private func reloadVideoData() {
        
        fillVideoData(videoContainer: videoContainers[(focus + 1) % videoContainers.count], index: focus)
        fillVideoData(videoContainer: videoContainers[(focus + 2) % videoContainers.count], index: focus + 1)
        fillVideoData(videoContainer: videoContainers[(focus + 3) % videoContainers.count], index: focus - 1)
        
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else {
            return
        }
        if count > 0 {
            videoContainers[focus + 1].play()
        }
    }
    
    
    private func configureVideoContainer() {
        let width = self.bounds.width
        let height = self.bounds.width
        for i in 0...2 {
            let container = VideoCell(frame: CGRect(x: CGFloat(i - 1) * width, y: 0, width: width, height: height))
            self.addSubview(container)
            self.videoContainers.append(container)
        }
        
    }
    
    private func videoCellDidSwipe(left: Bool) {
        let ci = (focus + 1) % videoContainers.count
        let ri = (ci + 1) % videoContainers.count
        let li = (ci + 2) % videoContainers.count
        
        let centerView = videoContainers[ci]
        let rightView = videoContainers[ri]
        let leftView = videoContainers[li]
        beforeAnimation()
        centerView.stop()
        if left {
            let leftFrame = leftView.frame
            leftView.frame = rightView.frame
            fillVideoData(videoContainer: leftView, index: focus + 2)
            UIView.animate(withDuration: 0.7, animations: {
                rightView.frame = centerView.frame
                centerView.frame = leftFrame
            }) { (finished) in
                self.afterAnimation()
                rightView.play()
            }
        } else {
            let rightFrame = rightView.frame
            rightView.frame = leftView.frame
            fillVideoData(videoContainer: rightView, index: focus - 2)
            UIView.animate(withDuration: 0.7, animations: {
                leftView.frame = centerView.frame
                centerView.frame = rightFrame
            }) { (finished) in
                self.afterAnimation()
                leftView.play()
            }
        }
    }
    
    func reloadVideo(at index: Int) {
        fillVideoData(videoContainer: videoContainers[(index + 1) % videoContainers.count], index: index)
    }
    
    private func fillVideoData(videoContainer: VideoCell, index: Int) {
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else { return }
        videoContainer.replaceCurrentItem(with: nil)
        if index >= 0 && index < count {
            guard let playerItem = self.dataSource?.playerItem(at: index, of: self) else { return }
            videoContainer.replaceCurrentItem(with: playerItem)
        }
    }
    
}

// image part
extension GalleryView {
    
    private func configureImageContainer() {
        let width = Double(self.bounds.size.width)
        let y = Double(self.bounds.size.height * 3 / 4)
        let distance = (width - imageWidth) / 2
        for i in 0...4 {
            let imageContainer = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            imageContainer.isHidden = true
            imageContainer.contentMode = .scaleAspectFit
            self.imageContainers.append(imageContainer)
            self.addSubview(imageContainer)
            let x = Double(i - 1) * distance + imageWidth / 2
            imageContainer.center = CGPoint(x: x, y: y)
        }
        
        imageContainers[2].transform = imageContainers[2].transform.scaledBy(x: 1.5, y: 1.5)
        
        reloadImageData()
        
    }
    
    private func reloadImageData() {
        fillImageData(imageContainer: imageContainers[(focus + 6) % imageContainers.count], index: focus - 1)
        fillImageData(imageContainer: imageContainers[(focus + 5) % imageContainers.count], index: focus - 2)
        fillImageData(imageContainer: imageContainers[(focus + 2) % imageContainers.count], index: focus)
        fillImageData(imageContainer: imageContainers[(focus + 3) % imageContainers.count], index: focus + 1)
        fillImageData(imageContainer: imageContainers[(focus + 4) % imageContainers.count], index: focus + 2)
    }
    
    private func imageCellDidSwipe(left: Bool) {
        
        let i2 = (focus + 2) % imageContainers.count
        let i0 = (i2 + 3) % imageContainers.count
        let i1 = (i2 + 4) % imageContainers.count
        let i3 = (i2 + 1) % imageContainers.count
        let i4 = (i2 + 2) % imageContainers.count
        
        if left {
            let i4Center = imageContainers[i4].center
            UIView.animate(withDuration: 0.7, animations: {
                self.imageContainers[i4].center = self.imageContainers[i3].center
                self.imageContainers[i3].center = self.imageContainers[i2].center
                self.imageContainers[i2].center = self.imageContainers[i1].center
                self.imageContainers[i1].center = self.imageContainers[i0].center
                
                self.imageContainers[i2].transform = self.imageContainers[i3].transform
                self.imageContainers[i3].transform = self.imageContainers[i3].transform.scaledBy(x: 1.5, y: 1.5)
            }) { (finished) in
                
            }
            self.imageContainers[i0].center = i4Center
            fillImageData(imageContainer: self.imageContainers[i0], index: focus + 3)
        } else {
            let i0Center = imageContainers[i0].center
            UIView.animate(withDuration: 0.7, animations: {
                self.imageContainers[i0].center = self.imageContainers[i1].center
                self.imageContainers[i1].center = self.imageContainers[i2].center
                self.imageContainers[i2].center = self.imageContainers[i3].center
                self.imageContainers[i3].center = self.imageContainers[i4].center
                
                self.imageContainers[i2].transform = self.imageContainers[i1].transform
                self.imageContainers[i1].transform = self.imageContainers[i1].transform.scaledBy(x: 1.5, y: 1.5)
            })
            self.imageContainers[i4].center = i0Center
            fillImageData(imageContainer: self.imageContainers[i4], index: focus - 3)
        }
    }
    
    private func fillImageData(imageContainer: UIImageView, index: Int) {
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else {
            return
        }
        imageContainer.image = nil
        if index < 0 || index >= count {
            imageContainer.isHidden = true
        } else {
            imageContainer.isHidden = false
            imageContainer.image = self.dataSource?.image(at: index, of: self)
        }
    }
    
    func reloadImage(at index: Int) {
        fillImageData(imageContainer: imageContainers[(index + 2) % imageContainers.count], index: index)
    }
    
}
