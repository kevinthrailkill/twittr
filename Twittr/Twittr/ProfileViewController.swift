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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
