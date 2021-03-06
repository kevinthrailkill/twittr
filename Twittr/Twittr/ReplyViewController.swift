//
//  ReplyViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/8/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


/// Class for a tweet to be replyed to
class ReplyViewController: ComposeViewController {

    var tweetToReply: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureComposeView()
        
        let image = UIImage(named: "twittericon.png")
        self.navigationItem.titleView = UIImageView(image: image)


    }
    
    override func configureComposeView() {
        
        if let owner = User._currentUser {
            profileImageView.setImageWith(owner.profileURL!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
        }else{
            print("Error no owner")
        }
        
        screenNameLabel.text = "@" + tweetToReply!.tweetOwner!.screenName!
        
        maxtext = 140 - tweetToReply!.tweetOwner!.screenName!.characters.count - 2
        
        super.configureComposeView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Sends out a reply tweet
    override func sendOutTweet() {
        
        super.sendOutTweet()
        
        let tweetText = screenNameLabel.text! + " " + composeTextView.text
        
        twitterAPIService.publish(tweetBody: tweetText, replyToStatusID: tweetToReply!.idStr) { (tweet, error) in
            if let tweet = tweet {
                print("reply success")
                print(tweet)
                self.delegate?.addNew(tweet: tweet)
                self.dismiss(animated: true)
            }else{
                print(error!.localizedDescription)
            }
        }
    }
}
