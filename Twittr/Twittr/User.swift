//
//  User.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Unbox

class User : Unboxable {
    
    var name: String?
    var screenName: String?
    var tagline: String?    
    var profileURL : URL?
    
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


