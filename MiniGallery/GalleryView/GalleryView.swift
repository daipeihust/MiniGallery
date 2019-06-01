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
    
    func setup(videoCell: VideoCell, at index: Int, of galleryView: GalleryView)
    
    func setup(photoCell: PhotoCell, at index: Int, of galleryView: GalleryView)
    
}


class GalleryView: UIView {
    
    var focus = 0
    
    var videoCells: [VideoCell] = []
    var photoCells: [PhotoCell] = []
    
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
        configureVideoCell()
        configurePhotoCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.reloadVideoData()
        self.reloadPhotoData()
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
        
        fillVideoData(videoContainer: videoCells[(focus + 1) % videoCells.count], index: focus)
        fillVideoData(videoContainer: videoCells[(focus + 2) % videoCells.count], index: focus + 1)
        fillVideoData(videoContainer: videoCells[(focus + 3) % videoCells.count], index: focus - 1)
        
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else {
            return
        }
        if count > 0 {
            videoCells[focus + 1].play()
        }
    }
    
    
    private func configureVideoCell() {
        let width = self.bounds.width
        let height = self.bounds.width
        for i in 0...2 {
            let container = VideoCell(frame: CGRect(x: CGFloat(i - 1) * width, y: 0, width: width, height: height))
            self.addSubview(container)
            self.videoCells.append(container)
        }
        
    }
    
    private func videoCellDidSwipe(left: Bool) {
        let ci = (focus + 1) % videoCells.count
        let ri = (ci + 1) % videoCells.count
        let li = (ci + 2) % videoCells.count
        
        let centerView = videoCells[ci]
        let rightView = videoCells[ri]
        let leftView = videoCells[li]
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
        fillVideoData(videoContainer: videoCells[(index + 1) % videoCells.count], index: index)
    }
    
    private func fillVideoData(videoContainer: VideoCell, index: Int) {
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else { return }
        
        videoContainer.prepareForReuse()
        if index >= 0 && index < count {
            self.dataSource?.setup(videoCell: videoContainer, at: index, of: self)
        }
    }
    
}

// image part
extension GalleryView {
    
    private func configurePhotoCell() {
        let width = Double(self.bounds.size.width)
        let y = Double(self.bounds.size.height * 3 / 4)
        let distance = (width - imageWidth) / 2
        for i in 0...4 {
            let photoCell = PhotoCell(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            photoCell.isHidden = true
            self.photoCells.append(photoCell)
            self.addSubview(photoCell)
            let x = Double(i - 1) * distance + imageWidth / 2
            photoCell.center = CGPoint(x: x, y: y)
        }
        
        photoCells[2].transform = photoCells[2].transform.scaledBy(x: 1.5, y: 1.5)
        
        reloadPhotoData()
        
    }
    
    private func reloadPhotoData() {
        fillPhotoData(photoCell: photoCells[(focus + 6) % photoCells.count], index: focus - 1)
        fillPhotoData(photoCell: photoCells[(focus + 5) % photoCells.count], index: focus - 2)
        fillPhotoData(photoCell: photoCells[(focus + 2) % photoCells.count], index: focus)
        fillPhotoData(photoCell: photoCells[(focus + 3) % photoCells.count], index: focus + 1)
        fillPhotoData(photoCell: photoCells[(focus + 4) % photoCells.count], index: focus + 2)
    }
    
    private func imageCellDidSwipe(left: Bool) {
        
        let i2 = (focus + 2) % photoCells.count
        let i0 = (i2 + 3) % photoCells.count
        let i1 = (i2 + 4) % photoCells.count
        let i3 = (i2 + 1) % photoCells.count
        let i4 = (i2 + 2) % photoCells.count
        
        if left {
            let i4Center = photoCells[i4].center
            UIView.animate(withDuration: 0.7, animations: {
                self.photoCells[i4].center = self.photoCells[i3].center
                self.photoCells[i3].center = self.photoCells[i2].center
                self.photoCells[i2].center = self.photoCells[i1].center
                self.photoCells[i1].center = self.photoCells[i0].center
                
                self.photoCells[i2].transform = self.photoCells[i3].transform
                self.photoCells[i3].transform = self.photoCells[i3].transform.scaledBy(x: 1.5, y: 1.5)
            }) { (finished) in
                
            }
            self.photoCells[i0].center = i4Center
            fillPhotoData(photoCell: self.photoCells[i0], index: focus + 3)
        } else {
            let i0Center = photoCells[i0].center
            UIView.animate(withDuration: 0.7, animations: {
                self.photoCells[i0].center = self.photoCells[i1].center
                self.photoCells[i1].center = self.photoCells[i2].center
                self.photoCells[i2].center = self.photoCells[i3].center
                self.photoCells[i3].center = self.photoCells[i4].center
                
                self.photoCells[i2].transform = self.photoCells[i1].transform
                self.photoCells[i1].transform = self.photoCells[i1].transform.scaledBy(x: 1.5, y: 1.5)
            })
            self.photoCells[i4].center = i0Center
            fillPhotoData(photoCell: self.photoCells[i4], index: focus - 3)
        }
    }
    
    private func fillPhotoData(photoCell: PhotoCell, index: Int) {
        guard let count = self.dataSource?.numberOfWorks(galleryView: self) else {
            return
        }
        photoCell.prepareForReuse()
        if index < 0 || index >= count {
            photoCell.isHidden = true
        } else {
            photoCell.isHidden = false
            self.dataSource?.setup(photoCell: photoCell, at: index, of: self)
        }
    }
    
    func reloadImage(at index: Int) {
        fillPhotoData(photoCell: photoCells[(index + 2) % photoCells.count], index: index)
    }
    
}
