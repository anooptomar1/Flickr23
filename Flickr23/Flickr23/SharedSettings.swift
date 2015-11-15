//
//  SharedSettings.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/10/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation
struct SharedSettings {
    static let flickrKey = <<insert key here>>
    static let flickrSecret = <<insert secret here>>
    
    // keys
    static let kUserIdKey = "userIdkey"
    static let kUsernameKey = "usernamekey"
    static let kUserKey = "userkey"
    
    // urls
    static let baseUrl = "https://www.flickr.com"
    static let requestTokenUrl = "https://www.flickr.com/services/oauth/request_token"
    static let accessTokenUrl = "https://www.flickr.com/services/oauth/access_token"
    
    // callbackUrl scheme
    static let callbackURL = "flickr23://authorize"
    
    // base rest url
    static let restBaseUrl = "https://api.flickr.com/services/rest/?format=json&nojsoncallback=1"
    
    // generate authUrl
    static func getAuthUrlFromToken(token: String) -> String{
        return "https://www.flickr.com/services/oauth/authorize?oauth_token=\(token)"
    }
}