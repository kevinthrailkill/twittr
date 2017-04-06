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
    
    
    var id: UInt64
    var idStr: String
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var tweetOwner: User?
    var entities: Entities?
    var retweetedStatus: Tweet?

    
    var favorited: Bool {
        didSet {
            if favorited {
                favoriteCount += 1
             //   TwitterClient.sharedInstance.favorite(["id": TweetID], favorite: true)
            } else {
                favoriteCount -= 1
             //   TwitterClient.sharedInstance.favorite(["id": TweetID], favorite: false)
            }
        }
    }
    var retweeted: Bool {
        didSet {
            if retweeted {
                retweetCount += 1
             //   TwitterClient.sharedInstance.retweet(["id": TweetID], retweet: true) { (tweet, error) in
              //      print("retweeted")
            
            } else {
                retweetCount -= 1
             //   TwitterClient.sharedInstance.retweet(["id": TweetID], retweet: false) { (tweet, error) in
              //      print("unretweeted")
              //  }
            }
        }
    }

    required init(unboxer: Unboxer) throws {
        
        self.id = try unboxer.unbox(key: "id")
        self.idStr = try unboxer.unbox(key: "id_str")
        
        self.text = unboxer.unbox(key: "text")
        self.retweetCount = unboxer.unbox(key: "retweet_count") ?? 0
        self.favoriteCount = unboxer.unbox(key: "favourites_count") ?? 0
        self.favorited = unboxer.unbox(key: "favorited") ?? false
        self.retweeted = unboxer.unbox(key: "retweeted") ?? false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.timeStamp = unboxer.unbox(key: "created_at", formatter: formatter)
        
        self.tweetOwner = unboxer.unbox(key: "user")
        self.entities = unboxer.unbox(key: "entities")
        
        self.retweetedStatus = unboxer.unbox(key: "retweeted_status")
        
    }
}


class Entities: Unboxable {
    
    var mediaArray: [Media]?
    
    required init(unboxer: Unboxer) throws {
        self.mediaArray = unboxer.unbox(key: "media")
        
    }
    
}

class Media : Unboxable {
    
    var type: String?
    var urlInTweet: String?
    var mediaURLHTTPS: URL?
    
    required init(unboxer: Unboxer) throws {
        
        self.type = unboxer.unbox(key: "type")
        self.urlInTweet = unboxer.unbox(key: "url")
        let mediaUrlString : String?  = unboxer.unbox(key: "media_url_https")
        if let urlstring = mediaUrlString {
            self.mediaURLHTTPS = URL(string: urlstring)
        }
        
        
    }
    
    
}
