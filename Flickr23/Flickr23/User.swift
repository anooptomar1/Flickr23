//
//  User.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/10/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation
class User: NSObject, NSCoding{
    
    var userId: String!
    var username: String!
    
    init(id: String, name: String){
        self.userId = id
        self.username = name
        super.init()
    }
    
    // serialization
    required init(coder aDecoder: NSCoder) {
        userId = aDecoder.decodeObjectForKey(SharedSettings.kUserIdKey) as! String
        username = aDecoder.decodeObjectForKey(SharedSettings.kUsernameKey) as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userId, forKey: SharedSettings.kUserIdKey)
        aCoder.encodeObject(username, forKey: SharedSettings.kUsernameKey)
    }
    
    // convert object to concrete class
    static func createUserObjectFromResponse(response: AnyObject) -> User?{
        let responseDictionary = response as! NSDictionary
        //print(responseDictionary)
        let stat = responseDictionary["stat"]
        guard let state = stat where state as! String == "ok" else{
            print("response is not ok")
            return nil
        }
        
        let userInfo = responseDictionary["user"] as! NSDictionary
        let userId = userInfo["id"] as! String
        let username = (userInfo["username"] as! NSDictionary)["_content"] as! String
        return User(id: userId, name: username)
    }
}