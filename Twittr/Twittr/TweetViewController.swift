//
//  TweetViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


/// Class for when a user clicks on a tweet
class TweetViewController: UIViewController {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    let twitterAPIService = TwitterAPIService.sharedInstance
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "twittericon.png")
        self.navigationItem.titleView = UIImageView(image: image)

        
        //load xib file
        let nib = UINib(nibName: "TweetDetailCell", bundle: nil)
        tweetTableView.register(nib, forCellReuseIdentifier: "TweetDetailCell")
        
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 180


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func replyButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ReplySegue", sender: self)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplySegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let replyiewController = newTweetNavController.viewControllers[0] as! ReplyViewController
            
            if let tweetForOp = tweet.retweetedStatus {
                replyiewController.tweetToReply = tweetForOp
            }else{
                replyiewController.tweetToReply = tweet
            }
        }
    }
    

}

extension TweetViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell", for: indexPath) as! TweetDetailCell
        cell.tweet = tweet
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

}

extension TweetViewController : TweetCellDelegate {
    

    func goToUserProfileFor(userID: Int) {
        
    }

    
    
    
    /// Favorite a tweet
    ///
    /// - Parameters:
    ///   - tweetID: the tweet id of the favorite
    ///   - shouldFavorite: whether or not you should favorite
    ///   - indexPath: the location of the tweet in the table
    func favorite(tweetID: String, shouldFavorite: Bool, indexPath: IndexPath) {
        twitterAPIService.favorite(tweetID: tweetID, favorite: shouldFavorite) { (tweet, error) in
            if tweet != nil {
                self.tweet = tweet
              //  self.tweetTableView.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    /// Retweet a tweet
    ///
    /// - Parameters:
    ///   - tweetID: the tweet id of the favorite
    ///   - shouldRetweet: whether or not you should retweet
    ///   - indexPath: the location of the tweet in the table
    func retweet(tweetID: String, shouldRetweet: Bool, indexPath: IndexPath) {
        twitterAPIService.reweet(tweetID: tweetID, retweet: shouldRetweet) { (tweet, error) in
            if tweet != nil {
                self.tweet = tweet
                print("retweet success")
               // self.tweetTableView.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    /// Displays the reply VC so a user can reply to a tweet
    ///
    /// - Parameter indexPath: the location of the tweet in the table
    func reply(forCellAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ReplySegue", sender: self)
    }

    
}
