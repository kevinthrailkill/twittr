//
//  TweetCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/6/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import FaveButton
import AFNetworking


class TweetCell: UITableViewCell, FaveButtonDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetMediaImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var heartButton: FaveButton!
    @IBOutlet weak var retweetButton: FaveButton!
    @IBOutlet weak var replyButton: FaveButton!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    //retweet top
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!
    
    
    //media height constraint
    @IBOutlet weak var mediaImageViewHeightContraint: NSLayoutConstraint!
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func configure(){
        
        
        //prevents did select row from happening when selecting on stack view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStackViewTap))
        buttonStackView.addGestureRecognizer(tap)
        
        
        
        // if its a retweet, then grab retweeted status
        if let retweetedStatus = tweet.retweetedStatus {
            retweetUsernameLabel.text = tweet.tweetOwner!.screenName! + " retweeted"
            retweetImageView.isHidden = false
            retweetUsernameLabel.isHidden = false
            retweetLabelHeightConstraint.constant = 12
            tweetForOperations = retweetedStatus
            configureTweetCell(tweetToConfigure: retweetedStatus)
        }else{
            
            tweetForOperations = tweet
            configureTweetCell(tweetToConfigure: tweet)
            retweetImageView.isHidden = true
            retweetUsernameLabel.isHidden = true
            retweetLabelHeightConstraint.constant = 0
            
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
        timeLabel.text = tweetToConfigure.timeStamp!.ago
        
        if tweetToConfigure.retweetCount == 0 {
            retweetCountLabel.text = ""
        }else{
            retweetCountLabel.text = "\(tweetToConfigure.retweetCount)"
        }
        
        retweetButton.isSelected =  tweetToConfigure.retweeted
        
        if tweetToConfigure.favoriteCount == 0 {
            favoriteCountLabel.text = ""
        }else{
            favoriteCountLabel.text = "\(tweetToConfigure.favoriteCount)"
        }
        
        heartButton.isSelected = tweetToConfigure.favorited
        
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
    
    
    func handleStackViewTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
    }
    
    
    //Mark: FaveButton Delegate
    
    @IBAction func faveButtonPressed(_ sender: FaveButton) {

        if sender === heartButton {
            print("Favorite")
            
            if !sender.isSelected {
                tweetForOperations.favorited = false
                self.delegate?.favorite(tweetID: tweetForOperations.idStr, shouldFavorite: false)
            }else{
                tweetForOperations.favorited = true
                self.delegate?.favorite(tweetID: tweetForOperations.idStr, shouldFavorite: true)
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
                 self.delegate?.retweet(tweetID: tweetForOperations.idStr, shouldRetweet: false)
            }else{
                tweetForOperations.retweeted = true
                self.delegate?.retweet(tweetID: tweetForOperations.idStr, shouldRetweet: true)
            }
            
            if tweetForOperations.retweetCount == 0 {
                retweetCountLabel.text = ""
            }else{
                retweetCountLabel.text = "\(tweetForOperations.retweetCount)"
            }
            
        } else {
            print("Reply")
            
        }
        
        print(sender.isSelected)
        
    }
    
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if( faveButton === heartButton ){
            return colors
        }
        return nil
    }
    
    
}



