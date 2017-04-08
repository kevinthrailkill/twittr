//
//  TweetPageCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import FaveButton

class TweetPageCell: UITableViewCell, FaveButtonDelegate {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: FaveButton!
    @IBOutlet weak var favoriteButton: FaveButton!
    
    
    
    
    //retweet info
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var retweetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    
    
    var tweet : Tweet! {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    var indexPath: IndexPath!
    var tweetForOperations : Tweet!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(){
        
        

        // if its a retweet, then grab retweeted status
        if let retweetedStatus = tweet.retweetedStatus {
            retweetUsernameLabel.text = tweet.tweetOwner!.screenName! + " retweeted"
            retweetImageView.isHidden = false
            retweetUsernameLabel.isHidden = false
            retweetHeightConstraint.constant = 12
            tweetForOperations = retweetedStatus
            configureTweetCell(tweetToConfigure: retweetedStatus)
        }else{
            tweetForOperations = tweet
            configureTweetCell(tweetToConfigure: tweet)
            retweetImageView.isHidden = true
            retweetUsernameLabel.isHidden = true
            retweetHeightConstraint.constant = 0
            
        }
    }
    
    func configureTweetCell(tweetToConfigure: Tweet) {
        
        
        //  mediaImageViewHeightContraint.constant = 0
        
        if let owner = tweetToConfigure.tweetOwner {
            nameLabel.text = owner.name
            screenNameLabel.text = "@" + owner.screenName!
            
            profileImageView.setImageWith(owner.profileURL!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
        }else{
            print("Error no owner")
        }
        
        
        tweetTextLabel.text = tweetToConfigure.text
        timeLabel.text = tweetToConfigure.timeStamp!.humanReadable.datetime
        
        if tweetToConfigure.retweetCount == 0 {
            retweetCountLabel.text = "0"
        }else{
            retweetCountLabel.text = "\(tweetToConfigure.retweetCount)"
        }
        
        retweetButton.isSelected =  tweetToConfigure.retweeted
        
        if tweetToConfigure.favoriteCount == 0 {
            favoriteCountLabel.text = "0"
        }else{
            favoriteCountLabel.text = "\(tweetToConfigure.favoriteCount)"
        }
        
        favoriteButton.isSelected = tweetToConfigure.favorited
        
        if let media = tweetToConfigure.entities?.mediaArray {
            configureMedia(mediaArray: media)
        }
        
        if let tweetUrls = tweetToConfigure.entities?.urlArray {
            configureUrl(urlArray: tweetUrls)
        }
        
        
    }
    
    
    //need to figure out what to do with these urls,
    //currently just hiding
    func configureUrl(urlArray: [TweetURLType]) {
        for url in urlArray {
            
            print(url.displayUrl!)
            
            //currently just removing the url
            tweetTextLabel.text = tweetTextLabel.text?.replacingOccurrences(of: url.url!, with: "")
        }
    }
    
    
    func configureMedia(mediaArray: [Media]) {
        for media in mediaArray {
            tweetTextLabel.text = tweetTextLabel.text?.replacingOccurrences(of: media.urlInTweet!, with: "")
            
            // print(media.urlInTweet!)
            
            if(media.type! == "photo") {
                
                //                tweetMediaImageView.isHidden = false
                //                mediaImageViewHeightContraint.constant = 100
                //                tweetMediaImageView.layer.cornerRadius = 5
                //                tweetMediaImageView.clipsToBounds = true
                //
                //
                //                tweetMediaImageView.setImageWith(URLRequest(url:media.mediaURLHTTPS!), placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                //                    self.tweetMediaImageView.image = image
                //                    self.delegate?.reload(tweetCell: self, at: self.indexPath)
                //                }, failure: { (imageRequest, imageResponse, error) in
                //                    print(error.localizedDescription)
                //                })
                
                
            }
        }
        
    }
    
    
    
    
    
    //Mark: FaveButton Delegate
    
    @IBAction func faveButtonPressed(_ sender: FaveButton) {
        
        if sender === favoriteButton {
            print("Favorite")
            
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
            print("Retweet")
            
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
            print("Reply")
            
        }
    }
    
    
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if( faveButton === favoriteButton ){
            return colors
        }
        return nil
    }
    
}
