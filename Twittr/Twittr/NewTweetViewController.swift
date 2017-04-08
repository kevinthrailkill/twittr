//
//  NewTweetViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit



class NewTweetViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    
    var twitterAPIService: TwitterAPIService!
    let maxtext: Int = 150
    weak var delegate: NewTweetDelegate?
    
    @IBOutlet weak var characterRemainingCountButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tweetButtonPressed(_ sender: UIBarButtonItem) {
        
        twitterAPIService.publish(tweetBody: tweetTextView.text) { (tweet, error) in
            if let tweet = tweet {
                print("sucess")
                print(tweet)
                
                 self.delegate?.addNew(tweet: tweet)
                self.dismiss(animated: true)
            }else{
                print(error!.localizedDescription)
            }
        }
        
        self.dismiss(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTweetView()
    }
    
    func configureTweetView() {
        
        if let owner = User._currentUser {
            nameLabel.text = owner.name
            screenNameLabel.text = "@" + owner.screenName!
            
            profileImageView.setImageWith(owner.profileURL!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
        }else{
            print("Error no owner")
        }
        
        
        tweetTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterRemainingCountButton.title = "\(maxtext - textView.text.characters.count)"
        
        if textView.text.characters.count > 0 {
            tweetButton.isEnabled = true
        } else {
            tweetButton.isEnabled = false
        }
        
    }

    
}


