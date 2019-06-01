//
//  PhotoCell.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.image = nil
    }
    
    func setup(with viewModel: PhotoCellViewModel) {
        
        viewModel.startLoading()
        
        self.image = viewModel.photo.image
        
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if !isLoading {
                DispatchQueue.main.async {
                    self?.image = viewModel.photo.image
                }
            }
        }
        
    }
    
}
