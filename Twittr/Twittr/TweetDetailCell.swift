//
//  TweetDetailCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//
// Detail tweet cell for expanded view

import UIKit

class TweetDetailCell: TweetCell {
    
    
    override func configure() {
        super.configure()
        
        timeLabel.text = tweetForOperations.timeStamp!.humanReadable.datetime
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
