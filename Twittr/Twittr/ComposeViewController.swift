//
//  ComposeViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/8/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


/// Base compose class for tweet and reply
class ComposeViewController: UIViewController, UITextViewDelegate {

    //outlets
    @IBOutlet weak var tweetCharacterCountBarButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    
    //vars
    let twitterAPIService = TwitterAPIService.sharedInstance
    var maxtext: Int = 140
    weak var delegate: ComposeTweetDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "twittericon.png")
        self.navigationItem.titleView = UIImageView(image: image)

        
        configureComposeView()
        tweetCharacterCountBarButton.title = "\(maxtext)"

    }
    
    func configureComposeView() {
        composeTextView.becomeFirstResponder()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendOutTweet()
    }
    
    func sendOutTweet(){
    }
    
    @IBAction func cancelButtonPresses(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    //Mark: Textview Delegates
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tweetCharacterCountBarButton.title = "\(maxtext - textView.text.characters.count)"
        
        if textView.text.characters.count > 0 {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
        
    }

}
