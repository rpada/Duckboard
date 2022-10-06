//
//  Singleton.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/4/22.
//

import Foundation

class singlePhotoSingleton: NSObject {

    // from my On the Map project submission feedback and with help from https://knowledge.udacity.com/questions/900468
    
    var singularPhoto = [SinglePhoto]()
    
    class func sharedInstance() -> singlePhotoSingleton {
        struct Singleton {
            static var sharedInstance = singlePhotoSingleton()
        }
        return Singleton.sharedInstance
    }
}

class favoritePhoto: NSObject {
    
    var favePhoto = [FavoritePhoto]()
    
    class func sharedInstance() -> favoritePhoto {
        struct Singleton {
            static var sharedInstance = favoritePhoto()
        }
        return Singleton.sharedInstance
    }
}
