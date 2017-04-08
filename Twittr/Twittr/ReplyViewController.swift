//
//  ReplyViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/8/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class ReplyViewController: ComposeViewController {

    var tweetToReply: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureComposeView()

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
    
    override func sendOutTweet() {
        
        super.sendOutTweet()
        
        let tweetText = screenNameLabel.text! + " " + composeTextView.text
        
        twitterAPIService.publish(tweetBody: tweetText, replyToStayusID: tweetToReply!.idStr) { (tweet, error) in
            if let tweet = tweet {
                print("reply success")
                print(tweet)
                self.dismiss(animated: true)
            }else{
                print(error!.localizedDescription)
            }
        }
    }
}
