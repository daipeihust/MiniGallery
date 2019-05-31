//
//  ImageCacher.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/31.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class DataCacher {
    class func save(data: Data, for url: String) -> URL? {
        
        guard let fileUrl = fileUrlFromUrl(url: url) else {
            return nil
        }
        
        do {
            try data.write(to: fileUrl)
            return fileUrl
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func read(url: String) -> Data? {
        
        guard let fileUrl = fileUrlFromUrl(url: url) else {
            return nil
        }
        
        return try? Data(contentsOf: fileUrl)
    }
    
    class func clear(url: String) {
        
        guard let fileUrl = fileUrlFromUrl(url: url) else {
            return
        }
        
        try? FileManager.default.removeItem(at: fileUrl)
    }
    
    class func exist(url: String) -> Bool {
        guard let fileUrl = fileUrlFromUrl(url: url) else {
            return false
        }
        let isExist = FileManager.default.fileExists(atPath: fileUrl.path)
        return isExist
    }
    
    class func fileUrlFromUrl(url: String) -> URL? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        let fileName = url.absoluteString.md5 + "." + url.pathExtension
        
        guard let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return dir.appendingPathComponent(fileName)
    }
    
}
