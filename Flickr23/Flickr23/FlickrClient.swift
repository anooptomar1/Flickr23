//
//  FlickrClient.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/10/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation
class FlickrClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?) -> ())?
    
    // singleton for shared instance of token
    class var sharedInstance: FlickrClient{
        struct Static {
            static let instance = FlickrClient(baseURL: NSURL(string: SharedSettings.baseUrl)!, consumerKey: SharedSettings.flickrKey, consumerSecret: SharedSettings.flickrSecret)
        }
        return Static.instance
    }
    
    func login(completion: (user: User?) -> Void){
        
        loginCompletion = completion
        
        FlickrClient.sharedInstance.requestSerializer.removeAccessToken()
        FlickrClient.sharedInstance.fetchRequestTokenWithPath(SharedSettings.requestTokenUrl, method: "GET", callbackURL: NSURL(string: SharedSettings.callbackURL), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            let authUrl = NSURL(string: SharedSettings.getAuthUrlFromToken(requestToken.token))!
            
            UIApplication.sharedApplication().openURL(authUrl)
            }) { (error:NSError!) -> Void in
                print(error)
        }
    }
    
    func openUrl(url: NSURL){
        FlickrClient.sharedInstance.fetchAccessTokenWithPath(SharedSettings.accessTokenUrl, method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (token: BDBOAuthToken!) -> Void in
            FlickrClient.sharedInstance.requestSerializer.saveAccessToken(token)
            
            FlickrClient.sharedInstance.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.test.login"], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                
                self.loginCompletion!(user: User.createUserObjectFromResponse(response))
                
                
                }, failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                    print(error)
                    self.loginCompletion!(user: nil)
            })
            
            }) { (error: NSError!) -> Void in
                print(error.localizedDescription)
        }
    }
    
    func getFavList(completion: ([Photo])->Void){
        FlickrClient.sharedInstance.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.favorites.getList"], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            
            completion(Photo.dictionaryToPhoto(((response as! NSDictionary)["photos"] as! NSDictionary)["photo"] as! [NSDictionary]))
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
        }
    }
    
    func setFavoriteOff(id: String, completion: (Bool) -> Void){
        FlickrClient.sharedInstance.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.favorites.remove","photo_id":id], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                let stat = (response as! NSDictionary)["stat"] as! String
            if stat == "ok"{
                    completion(true)
            }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print(error)
        }
    }
    
    func setFavoriteOn(id: String, completionHandler: (Bool) -> Void){
        FlickrClient.sharedInstance.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.favorites.add","photo_id":id], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let stat = (response as! NSDictionary)["stat"] as! String
            if stat == "ok"{
                completionHandler(true)
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
        }
    }
    
    func getInterestingness(page: Int, count: Int, completionHandler: ([Photo])->Void){
        FlickrClient.sharedInstance.GET(SharedSettings.restBaseUrl, parameters: ["method":"flickr.interestingness.getList", "per_page":count,"page":page], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            completionHandler(Photo.dictionaryToPhoto(((response as! NSDictionary)["photos"] as! NSDictionary)["photo"] as! [NSDictionary]))
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error)
        }
    }
    
    func logout() -> Bool{
        let deauth = FlickrClient.sharedInstance.deauthorize()
        if deauth{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(SharedSettings.kUserKey)
        }
        return deauth
    }
}
