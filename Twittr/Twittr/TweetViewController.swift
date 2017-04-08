//
//  TweetViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var twitterAPIService: TwitterAPIService!
    var tweet : Tweet!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //load xib file
        let nib = UINib(nibName: "TweetPageCell", bundle: nil)
        tweetTableView.register(nib, forCellReuseIdentifier: "TweetPageCell")
        
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 180


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplySegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let replyiewController = newTweetNavController.viewControllers[0] as! ReplyViewController
            
            replyiewController.twitterAPIService = twitterAPIService
            replyiewController.tweetToReply = tweet
        }
    }
    

}

extension TweetViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetPageCell", for: indexPath) as! TweetPageCell
        cell.tweet = tweet
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

}

extension TweetViewController : TweetCellDelegate {
    
    
    func reload(tweetCell: TweetCell, at indexPath: IndexPath ) {
    }
    
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

    
}