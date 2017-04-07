//
//  TweetCellProtocols.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/6/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation

protocol TweetCellDelegate: class {
    
    func reload(tweetCell: TweetCell, at indexPath: IndexPath)
    
    func favorite(tweetID: String, shouldFavorite: Bool)
    
    func retweet(tweetID: String, shouldRetweet: Bool)
    
    
}


protocol NewTweetDelegate : class {
    func addNew(tweet: Tweet)
}
