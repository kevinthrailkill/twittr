//
//  TweetCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/8/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//
// Generic Tweet cell that all other tweet cells extend


import UIKit
import FaveButton
import AFNetworking


class TweetCell: UITableViewCell {


    //outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetMediaImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    
    //action buttons
    @IBOutlet weak var favoriteButton: FaveButton!
    @IBOutlet weak var retweetButton: FaveButton!
    @IBOutlet weak var replyButton: FaveButton!
    
    //retweet top
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var retweetHeightConstraint: NSLayoutConstraint!
    
    
    var tweet : Tweet! {
        didSet {
            configure()
        }
    }
    
    var tweetForOperations : Tweet!
    weak var delegate: TweetCellDelegate?
    var indexPath: IndexPath!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //configures the tweet cell
    func configure(){
        
        // if its a retweet, then grab retweeted status
        if let retweetedStatus = tweet.retweetedStatus {
            retweetUsernameLabel.text = tweet.tweetOwner!.screenName! + " retweeted"
            retweetImageView.isHidden = false
            retweetUsernameLabel.isHidden = false
            retweetHeightConstraint.constant = 12
            tweetForOperations = retweetedStatus
        }else{
            retweetImageView.isHidden = true
            retweetUsernameLabel.isHidden = true
            retweetHeightConstraint.constant = 0
            tweetForOperations = tweet
            
        }
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageViewTapped))
        profileImageView.addGestureRecognizer(profileTap)
        
        
        if let owner = tweetForOperations.tweetOwner {
            nameLabel.text = owner.name
            screenNameLabel.text = "@" + owner.screenName!
            
            profileImageView.setImageWith(owner.profileURL!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
        }else{
            print("Error no owner")
        }
        
        tweetTextLabel.text = tweetForOperations.text
        
        
        if tweetForOperations.retweetCount == 0 {
            retweetCountLabel.text = ""
        }else{
            retweetCountLabel.text = "\(tweetForOperations.retweetCount)"
        }
        
        retweetButton.isSelected =  tweetForOperations.retweeted
        
        if tweetForOperations.favoriteCount == 0 {
            favoriteCountLabel.text = ""
        }else{
            favoriteCountLabel.text = "\(tweetForOperations.favoriteCount)"
        }
        
        favoriteButton.isSelected = tweetForOperations.favorited
        
        if let media = tweetForOperations.entities?.mediaArray {
            configureMedia(mediaArray: media)
        }
        
        if let tweetUrls = tweetForOperations.entities?.urlArray {
            configureUrl(urlArray: tweetUrls)
        }
        
    }
    
    func handleProfileImageViewTapped(sender: UITapGestureRecognizer) {
        // just prevents the cell selection from happening if you press the stack view
        print("hit profile imageview")
        
        print("User id: \(tweetForOperations.tweetOwner!.userID)")
        
        self.delegate?.goToUserProfileFor(userID: tweetForOperations.tweetOwner!.userID)
        
        
    }

    
    
    
    
    //currently just removing the urls from the tweet display
    func configureUrl(urlArray: [TweetURLType]) {
        for url in urlArray {
            print(url.displayUrl!)
            //currently just removing the url
            tweetTextLabel.text = tweetTextLabel.text?.replacingOccurrences(of: url.url!, with: "")
        }
    }
    
    //currently just removing the media urls from the tweet display
    func configureMedia(mediaArray: [Media]) {
        for media in mediaArray {
            tweetTextLabel.text = tweetTextLabel.text?.replacingOccurrences(of: media.urlInTweet!, with: "")
            if(media.type! == "photo") {
            }
        }
    }
    
    
    
    /// If a fave button is pressesd, the according methods are called depending if its a reply, retweet, or favorite
    ///
    /// - Parameter sender: self
    @IBAction func faveButtonPressed(_ sender: FaveButton) {
        
        if sender === favoriteButton {
            print("Favorite Presses")
            
            if !sender.isSelected {
                tweetForOperations.favorited = false
                self.delegate?.favorite(tweetID: tweetForOperations.idStr, shouldFavorite: false, indexPath: self.indexPath)
            }else{
                tweetForOperations.favorited = true
                self.delegate?.favorite(tweetID: tweetForOperations.idStr, shouldFavorite: true, indexPath: self.indexPath)
            }
            
            if tweetForOperations.favoriteCount == 0 {
                favoriteCountLabel.text = ""
            }else{
                favoriteCountLabel.text = "\(tweetForOperations.favoriteCount)"
            }
            
        } else if sender === retweetButton {
            print("Retweet Pressed")
            
            if !sender.isSelected {
                tweetForOperations.retweeted = false
                self.delegate?.retweet(tweetID: tweetForOperations.idStr, shouldRetweet: false, indexPath: self.indexPath)
            }else{
                tweetForOperations.retweeted = true
                self.delegate?.retweet(tweetID: tweetForOperations.idStr, shouldRetweet: true, indexPath: self.indexPath)
            }
            
            if tweetForOperations.retweetCount == 0 {
                retweetCountLabel.text = ""
            }else{
                retweetCountLabel.text = "\(tweetForOperations.retweetCount)"
            }
            
        } else {
            print("Reply Pressed")
            self.delegate?.reply(forCellAt: indexPath)
        }
    }

}

extension TweetCell : FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if faveButton === favoriteButton {
            return colors
        }
        return nil
    }
}
