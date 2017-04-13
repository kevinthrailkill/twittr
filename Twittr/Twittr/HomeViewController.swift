//
//  HomeViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit




class HomeViewController: ShowTweetsViewController {


    var profileIdToGoTo : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func getTweets(refreshing : Bool, maxID: String?) {
        twitterAPIService.getHomeTimeline(maxID: maxID) {
            (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                print(tweets)
                if self.isLoadingMoreData == .loadingMoreData {
                    self.isLoadingMoreData = .notLoadingMoreData
                    self.loadingMoreView!.stopAnimating()
                    //removes the first element of the returned array as it is repeated
                    var tweetsWithoutFirst = tweets
                    tweetsWithoutFirst.remove(at: 0)
                    self.tweetsArray.append(contentsOf: tweetsWithoutFirst)
                }else{
                    self.tweetsArray = tweets
                    if refreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                self.tweetsTableView.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        
        twitterAPIService.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reply(forCellAt indexPath: IndexPath) {
        indexPathToReload = indexPath
        self.performSegue(withIdentifier: "ReplyFromHomeScreenSegue", sender: self)
    }
    
    override func goToUserProfileFor(userID: Int) {
        profileIdToGoTo = userID
        self.performSegue(withIdentifier: "ShowProfileSegue", sender: self)
    }

    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        
//        
//        self.performSegue(withIdentifier: "TweetPageSegue", sender: self)
//        
//    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTweetSegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let newTweetViewController = newTweetNavController.viewControllers[0] as! NewTweetViewController
            newTweetViewController.delegate = self
        } else if segue.identifier == "TweetPageSegue" {
            let tweetController = segue.destination as! TweetViewController
            let tweetCell = tweetsTableView.cellForRow(at: indexPathToReload!) as! TweetBasicCell
            tweetController.tweet = tweetCell.tweet
        }else if segue.identifier == "ReplyFromHomeScreenSegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let replyiewController = newTweetNavController.viewControllers[0] as! ReplyViewController
            let tweetCell = tweetsTableView.cellForRow(at: indexPathToReload!) as! TweetBasicCell
            replyiewController.tweetToReply = tweetCell.tweetForOperations
            replyiewController.delegate = self
            indexPathToReload = nil
        } else if segue.identifier == "ShowProfileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userID = profileIdToGoTo
            profileIdToGoTo = nil
        }
    }
}


