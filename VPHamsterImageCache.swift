//
//  VPHamsterImageCache.swift
//  VPHamsterImageCache
//
//  Created by Vlad Petruk on 1/3/16.
//  Copyright © 2016 Vlad Petruk. All rights reserved.
//

import UIKit

class VPHamsterImageCache {
    
    private let imageCache = NSCache()
    
    class var sharedCache: VPHamsterImageCache {
        struct Static {
            static let instance: VPHamsterImageCache = VPHamsterImageCache()
        }
        return Static.instance
    }
    
    func getImageForURLString(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () in
            
            let imageData = self.imageCache.objectForKey(urlString) as? NSData
            
            if let goodData = imageData {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            let downloadImageTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if error != nil {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    self.imageCache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadImageTask.resume()
        })
    }
}