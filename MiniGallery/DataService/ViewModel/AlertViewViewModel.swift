//
//  AlertViewViewModel.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation
import UIKit

class AlertViewViewModel {
    var alertTitle = ""
    var alertMsg = ""
    var shouldShow = Observable(false)
    var defauleHandler: ((UIAlertAction) -> Void)?
}
