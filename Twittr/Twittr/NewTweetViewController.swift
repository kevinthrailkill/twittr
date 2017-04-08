//
//  NewTweetViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit



class NewTweetViewController: ComposeViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: NewTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureComposeView() {
        super.configureComposeView()
        
        if let owner = User._currentUser {
            nameLabel.text = owner.name
            screenNameLabel.text = "@" + owner.screenName!
            
            profileImageView.setImageWith(owner.profileURL!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
        }else{
            print("Error no owner")
        }
        
    }
    
    override func sendOutTweet() {
        super.sendOutTweet()
        
        twitterAPIService.publish(tweetBody: composeTextView.text, replyToStayusID: nil) { (tweet, error) in
            if let tweet = tweet {
                print("sucess")
                print(tweet)
                
                self.delegate?.addNew(tweet: tweet)
                self.dismiss(animated: true)
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


