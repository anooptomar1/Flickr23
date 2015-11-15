//
//  ImageUrlBuilder.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/12/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation

enum ImageSize: Character{
    case small = "s",
    large = "q",
    thumbnail100LongSide = "t",
    small240LongSide = "m",
    small320LongSide = "n",
    medium640LongSide = "z",
    medium800LongSide = "c",
    large1024LongSide = "b",
    large1600LongSide = "h",
    large22048LongSide="k",
    original = "o"
    
}


// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
class ImageBuilder {
    class func getImage(photo: Photo, imageType: ImageSize, completionHandler: ((UIImage?)->Void)){
        let url = buildImageUrl(photo, size: imageType)
        //print(url)
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(NSURL(string: url)!){
            (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode == 200 else{
                print("status is not OK")
                return
            }
            
            let im = UIImage(data: NSData(contentsOfURL: location!)!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(im)
            })
        }
        task.resume()
    }
    
    class func buildImageUrl(photo: Photo, size: ImageSize)->String{
        return "https://farm\(photo.farm!).staticflickr.com/\(photo.server!)/\(photo.id!)_\(photo.secret!)_\(size.rawValue).jpg"
    }
}