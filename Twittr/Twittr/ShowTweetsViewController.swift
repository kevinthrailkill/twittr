//
//  ShowTweetsViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/10/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//
// Tweets view contoller for home page

import UIKit

class ShowTweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    //vars
    let twitterAPIService = TwitterAPIService.sharedInstance
    var tweetsArray: [Tweet] = []
    let refreshControl = UIRefreshControl()
    var indexPathToReload : IndexPath? = nil

    var isLoadingMoreData : IsLoadingMore = .notLoadingMoreData
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image = UIImage(named: "twittericon.png")
        self.navigationItem.titleView = UIImageView(image: image)
        
        
        //load xib file
        let nib = UINib(nibName: "TweetBasicCell", bundle: nil)
        tweetsTableView.register(nib, forCellReuseIdentifier: "TweetBasicCell")
        
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 90
        
        
        getTweets(refreshing: false, maxID: nil)
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tweetsTableView.addSubview(loadingMoreView!)
        
        var insets = tweetsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetsTableView.contentInset = insets
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadCell()
        
    }
    
    
    fileprivate func reloadCell() {
        if let index = indexPathToReload {
            //reload data after coming back from detail tweet view
            tweetsTableView.beginUpdates()
            tweetsTableView.reloadRows(at: [index], with: .fade)
            tweetsTableView.endUpdates()
            indexPathToReload = nil
        }
    }
    
    
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getTweets(refreshing: true, maxID: nil)
    }
    
    

    
    /// Gets the tweets by calling twitter api
    ///
    /// - Parameters:
    ///   - refreshing: whether or not the view is refresshing
    ///   - maxID: the id of the earliest tweet we have
    func getTweets(refreshing : Bool, maxID: String?) {
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
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (isLoadingMoreData == .notLoadingMoreData) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging) {
                isLoadingMoreData = .loadingMoreData
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    
    
    /// Gets the older tweets in my timeline
    func loadMoreData() {
        let maxID = tweetsArray[tweetsArray.endIndex-1].idStr
        getTweets(refreshing: true, maxID: maxID)
    }

    deinit {
        print("Tweets view gone")
    }
    
    
    /// Logout of twitter
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        twitterAPIService.logout()
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

extension ShowTweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetBasicCell", for: indexPath) as! TweetCell
        let tweet = tweetsArray[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    
    //for profile view change
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPathToReload = indexPath
        self.performSegue(withIdentifier: "TweetPageSegue", sender: self)
        
    }
}

extension ShowTweetsViewController : TweetCellDelegate, ComposeTweetDelegate {
    
    

    /// Favorite a tweet
    ///
    /// - Parameters:
    ///   - tweetID: the tweet id of the favorite
    ///   - shouldFavorite: whether or not you should favorite
    ///   - indexPath: the location of the tweet in the table
    func favorite(tweetID: String, shouldFavorite: Bool, indexPath: IndexPath) {
        twitterAPIService.favorite(tweetID: tweetID, favorite: shouldFavorite) { (tweet, error) in
            if tweet != nil {
                
                print("favorite success")
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
                
                print("retweet success")
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    /// Displays the reply VC so a user can reply to a tweet
    ///
    /// - Parameter indexPath: the location of the tweet in the table
    func reply(forCellAt indexPath: IndexPath) {
        
    }
    
    func goToUserProfileFor(userID: Int) {
        
    }
    
    /// Adds the new tweet to table at top
    ///
    /// - Parameter tweet: the tweet to add
    func addNew(tweet: Tweet) {
        tweetsArray.insert(tweet, at: 0)
        tweetsTableView.reloadData()
    }
    
}
