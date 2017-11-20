//
//  LogoDownloader.swift
//  Yuftee
//
//  Created by AppsCreationTech on 25/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

class LogoDownloader {
    
    // Maybe cache images here??
    
    class func getImage(url: String, handler: ((image: UIImage?) -> Void)) {
        let nsurl = NSURL(string: url)
        if nsurl == nil {
            handler(image: nil)
            return
        }
        var imageRequest: NSURLRequest = NSURLRequest(URL: nsurl!)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: { response, data, error in
                if error == nil
                {
                    let img: UIImage? = UIImage(data: data)
                    handler(image: img)
                } else {
//                    handler(image: nil)
                }
        })
    }
    
}
