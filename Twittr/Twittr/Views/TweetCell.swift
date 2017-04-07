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
        
        print(tweetToConfigure.favoriteCount)
        
        tweetTextLabel.text = tweetToConfigure.text
        timeLabel.text = tweetToConfigure.timeStamp!.ago
        
        if tweetToConfigure.retweetCount == 0 {
            retweetCountLabel.text = ""
        }else{
            retweetCountLabel.text = "\(tweetToConfigure.retweetCount)"
        }
        
        if tweetToConfigure.favoriteCount == 0 {
            favoriteCountLabel.text = ""
        }else{
            favoriteCountLabel.text = "\(tweetToConfigure.favoriteCount)"
        }
        
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

        if sender === heartButton {
            print("Favorite")
            
            if sender.isSelected {
                tweetForOperations.favorited = false
            }else{
                tweetForOperations.favorited = true
            }
            
            if tweetForOperations.favoriteCount == 0 {
                favoriteCountLabel.text = ""
            }else{
                favoriteCountLabel.text = "\(tweetForOperations.favoriteCount)"
            }
            
            
        } else if sender === retweetButton {
            print("Retweet")
            
            if sender.isSelected {
                tweetForOperations.retweeted = false
            }else{
                tweetForOperations.retweeted = true
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

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}


//Mark: Date formatting code from https://github.com/tejen/codepath-twitter

public struct humanReadableDate {
    fileprivate var base: Date
    
    init(date: Date) {
        base = date
    }
    
    public var date: (unit: String, timeSince: Double) {
        var unit = "/"
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let timeSince = Double(formatter.string(from: base))!
        formatter.dateFormat = "d/yy"
        unit += formatter.string(from: base)
        return (unit, timeSince)
    }
    
    public var datetime: String {
        let (unit, timeSince) = date
        let value = Int(timeSince)
        var l18n = "\(value)\(unit), "
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        l18n += formatter.string(from: base)
        return l18n
    }
}

// MARK: - NSDate
public extension Date {
    
    public var humanReadable: humanReadableDate {
        return humanReadableDate(date: self)
    }
    
    public var ago: String {
        var unit = "s"
        var timeSince = abs(self.timeIntervalSinceNow as Double); // in seconds
        let reductionComplete = reduced(unit, value: timeSince)
        
        while(reductionComplete != true) {
            unit = "m"
            timeSince = round(timeSince / 60)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "h"
            timeSince = round(timeSince / 60)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "d"
            timeSince = round(timeSince / 24)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "w"
            timeSince = round(timeSince / 7)
            if reduced(unit, value: timeSince) { break; }
            
            (unit, timeSince) = self.humanReadable.date;   break
        }
        
        let value = Int(timeSince)
        return "\(value)\(unit)"
    }
    
    fileprivate func reduced(_ unit: String, value: Double) -> Bool {
        let value = Int(round(value))
        switch unit {
        case "s":
            return value < 60
        case "m":
            return value < 60
        case "h":
            return value < 24
        case "d":
            return value < 7
        case "w":
            return value < 4
        default: // include "w". cannot reduce weeks
            return true
        }
    }
}

