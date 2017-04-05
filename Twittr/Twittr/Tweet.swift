//
//  Tweet.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Unbox


class Tweet: Unboxable {
    
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int?
    var favoriteCount: Int?
    

    required init(unboxer: Unboxer) throws {
        self.text = unboxer.unbox(key: "text")
        self.retweetCount = unboxer.unbox(key: "retweet_count") ?? 0
        self.favoriteCount = unboxer.unbox(key: "favourites_count") ?? 0
        
        let timeStampString : String? = unboxer.unbox(key: "created_at")
        if let dateString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timeStamp = formatter.date(from: dateString)
        }
    }
}
