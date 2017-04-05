//
//  TweetsViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var twitterAPIService : TwitterAPIService!
    var tweetsArray: [Tweet] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        twitterAPIService.getHomeTimeline() {
            (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                print(tweets)
                self.tweetsArray = tweets
                self.tweetsTableView.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) 
        
        let tweet = tweetsArray[indexPath.row]
        
        cell.textLabel?.text = tweet.text
        
        
        return cell
    }
    
    
    
}
