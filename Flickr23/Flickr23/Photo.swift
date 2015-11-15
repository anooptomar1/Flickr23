//
//  Photo.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/12/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import Foundation
class Photo {
    var farm: Int?
    var id: String?
    var isfamily: Int?
    var isfriend: Int?
    var ispublic: Int?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?
    var fav: Bool = false
    
    init(farm: Int, id: String, isfamily: Int, isfriend: Int, ispublic: Int, owner: String, secret: String, server: String, title: String){
        self.farm = farm
        self.id = id
        self.isfamily = isfamily
        self.isfriend = isfriend
        self.ispublic = ispublic
        self.owner = owner
        self.secret = secret
        self.server = server
        self.title = title
    }
    
    class func dictionaryToPhoto(photoArray: [NSDictionary]) -> [Photo]{
        //print(photoArray)
        var photoCollection: [Photo] = []
        for item in photoArray{
            let farm = item["farm"] as! Int
            let id = item["id"] as! String
            let isfamily = item["isfamily"] as! Int
            let isfriend = item["isfriend"] as! Int
            let ispublic = item["ispublic"] as! Int
            let owner = item["owner"] as! String
            let secret = item["secret"] as! String
            let server = item["server"] as! String
            let title = item["title"] as! String
            let photo = Photo(farm: farm, id: id, isfamily: isfamily, isfriend: isfriend, ispublic: ispublic, owner: owner, secret: secret, server: server, title: title)
            photoCollection.append(photo)
        }
        return photoCollection
    }
}