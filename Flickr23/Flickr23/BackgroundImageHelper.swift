//
//  BackgroundHelper.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/12/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation
class BackgroundImageHelper {
    class func getBackgroundImage(perPage: Int, pageNumber: Int, completionHandler: (UIImage?)-> Void){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.interestingness.getList", "api_key":SharedSettings.flickrKey, "per_page": perPage, "page":pageNumber], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // check for nil objects here
            let photoCollection = Photo.dictionaryToPhoto(((response as! NSDictionary)["photos"] as! NSDictionary)["photo"] as! [NSDictionary])
            let selectedPhoto = photoCollection[Int(arc4random_uniform(10))]
            ImageBuilder.getImage(selectedPhoto, imageType: ImageSize.medium640LongSide, completionHandler: { (im: UIImage?) -> Void in
                guard let image = im else{
                    completionHandler(nil)
                    return
                }
                
                completionHandler(image)
            })
            
        }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                print(error)
                completionHandler(nil)
        }
    }
}