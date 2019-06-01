//
//  ImageCacher.swift
//  MiniGallery
//
//  Created by DaiPei on 2019/5/31.
//  Copyright © 2019 DaiPei. All rights reserved.
//

import Foundation

class DataCacher {
    
    static var cacheDir: URL? {
        guard let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return dir
    }
    
    class func save(data: Data, for key: String) {
        if let dir = cacheDir {
            try? data.write(to: dir.appendingPathComponent(key))
        }
    }
    
    class func read(key: String) -> Data? {
        if let dir = cacheDir {
            return try? Data(contentsOf: dir.appendingPathComponent(key))
        }
        return nil
    }
    
    class func save(data: Data, for url: URL) -> URL? {
        
        guard let fileUrl = cacheUrlFromUrl(url: url) else {
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
    
    class func read(url: URL) -> Data? {
        
        guard let fileUrl = cacheUrlFromUrl(url: url) else {
            return nil
        }
        
        return try? Data(contentsOf: fileUrl)
    }
    
    class func clear(url: URL) {
        
        guard let fileUrl = cacheUrlFromUrl(url: url) else {
            return
        }
        
        try? FileManager.default.removeItem(at: fileUrl)
    }
    
    class func exist(url: URL) -> Bool {
        guard let fileUrl = cacheUrlFromUrl(url: url) else {
            return false
        }
        let isExist = FileManager.default.fileExists(atPath: fileUrl.path)
        return isExist
    }
    
    class func cacheUrlFromUrl(url: URL) -> URL? {
        
        let fileName = url.absoluteString.md5 + "." + url.pathExtension
        
        guard let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return dir.appendingPathComponent(fileName)
    }
    
}
