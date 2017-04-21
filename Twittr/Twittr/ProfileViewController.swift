//
//  ProfileViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/10/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class ProfileViewController: ShowTweetsViewController {

    var userID : Int?
    var userToDisplay: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        getUser { (shouldGetTweets) in
            if shouldGetTweets {
                //self.tweetsTableView.reloadData()
                self.getTweets(refreshing: false, maxID: nil)
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    func getUser(completion: @escaping (Bool) -> ()){
        twitterAPIService.getUserBYID(userID: userID!) { (user, error) in
            if let user = user {
                self.userToDisplay = user
                completion(true)
            }else{
                print(error!.localizedDescription)
                completion(false)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func getTweets(refreshing : Bool, maxID: String?) {
        
        
        
        twitterAPIService.getUserTimeline(userID: userID!, maxID: maxID) {
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
    
    override func reply(forCellAt indexPath: IndexPath) {
        indexPathToReload = indexPath
        self.performSegue(withIdentifier: "ReplyFromProfileScreenSegue", sender: self)
    }
    
    override func goToUserProfileFor(userID: Int) {
        
        if userID != self.userID {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileViewController.userID = userID
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let profileHeader = tweetsTableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell") as! ProfileHeaderCell
        
        profileHeader.user = userToDisplay
        
        return profileHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if userToDisplay == nil {
            return 0
        }
        
        return 202
    }
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplyFromProfileScreenSegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let replyiewController = newTweetNavController.viewControllers[0] as! ReplyViewController
            let tweetCell = tweetsTableView.cellForRow(at: indexPathToReload!) as! TweetBasicCell
            replyiewController.tweetToReply = tweetCell.tweetForOperations
            //replyiewController.delegate = self
            indexPathToReload = nil
        } else if segue.identifier == "NewTweetFromProfileSegue" {
            
        }
    }

}
