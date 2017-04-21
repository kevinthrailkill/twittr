//
//  ProfileHeaderCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/21/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    var user: User! {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(){
        print("Configuring Header Cell")
        
        
        nameLabel.text = user.name
        screenNameLabel.text = "@" + user.screenName!
        
        profileImageView.setImageWith(user.profileURL!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        if let bannerURL = user.profileBannerURL {
            bannerImageView.setImageWith(bannerURL)
        }        
        
        tweetsCountLabel.text = "\(user.tweetCount!)"
        followersCountLabel.text = "\(user.followerCount!)"
        followingCountLabel.text = "\(user.friendsCount!)"
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
