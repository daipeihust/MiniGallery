//
//  Observable.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/6/1.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class Observable<T> {
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var valueChanged: ((T)->Void)?
    
    func addObserver(fireNow: Bool = true, onChange: ((T)->Void)?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }
    
    func removeObserver() {
        valueChanged = nil
    }
}
