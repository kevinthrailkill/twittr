//
//  User.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Unbox
import Wrap

class User : Unboxable {
    
    var name: String?
    var screenName: String?
    var tagline: String?    
    var profileURL : URL?
    
    
    static var _currentUser: User?
    
    class var currentUser : User? {
        get {
            
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: [])
                    
                    _currentUser = User(dictionary: dictionary as! UnboxableDictionary)
                    
                }
            }
            
            return _currentUser
            
        }set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let dictionary: [String : Any] = try! wrap(user)
                
                let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()

        }
    }
    
    init(dictionary: UnboxableDictionary){
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screenName"] as? String
        self.tagline = dictionary["tagline"] as? String
        
        let profileUrlString : String?  = dictionary["profileURL"] as? String
        if let urlstring = profileUrlString {
            self.profileURL = URL(string: urlstring)
        }
        
    }
    
    
    required init(unboxer: Unboxer) throws {
        self.name = unboxer.unbox(key: "name")
        self.screenName = unboxer.unbox(key: "screen_name")
        self.tagline = unboxer.unbox(key: "description")
        
        let profileUrlString : String?  = unboxer.unbox(key: "profile_image_url_https")
        if let urlstring = profileUrlString {
            self.profileURL = URL(string: urlstring)
        }
    }
}


