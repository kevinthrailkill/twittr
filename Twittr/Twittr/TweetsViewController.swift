//
//  TweetsViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/5/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


enum IsLoadingMore: Int {
    case loadingMoreData, notLoadingMoreData
}

class TweetsViewController: UIViewController {

    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var twitterAPIService : TwitterAPIService!
    var tweetsArray: [Tweet] = []
    let refreshControl = UIRefreshControl()
    var indexPathToReload : IndexPath? = nil

    
    
    var isLoadingMoreData : IsLoadingMore = .notLoadingMoreData
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    private func getTweets(refreshing : Bool, maxID: UInt64?) {
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
    
    
    func loadMoreData() {
        
        let maxID = tweetsArray[tweetsArray.endIndex-1].id
        
        getTweets(refreshing: true, maxID: maxID)
        
        
    }
    
    
    deinit {
        print("Tweets view gone")
        twitterAPIService = nil
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        
        twitterAPIService.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTweetSegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let newTweetViewController = newTweetNavController.viewControllers[0] as! NewTweetViewController
    
            newTweetViewController.twitterAPIService = twitterAPIService
            newTweetViewController.delegate = self
        } else if segue.identifier == "TweetPageSegue" {
            let tweetController = segue.destination as! TweetViewController
            tweetController.twitterAPIService = twitterAPIService
            let tweetCell = tweetsTableView.cellForRow(at: indexPathToReload!) as! TweetBasicCell
            tweetController.tweet = tweetCell.tweet
        }else if segue.identifier == "ReplyFromHomeScreenSegue" {
            let newTweetNavController = segue.destination
                as! UINavigationController
            let replyiewController = newTweetNavController.viewControllers[0] as! ReplyViewController
            replyiewController.twitterAPIService = twitterAPIService
            let tweetCell = tweetsTableView.cellForRow(at: indexPathToReload!) as! TweetBasicCell
            replyiewController.tweetToReply = tweetCell.tweet
            indexPathToReload = nil
        }
    }
}


extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPathToReload = indexPath
        
        self.performSegue(withIdentifier: "TweetPageSegue", sender: self)
        
    }
    
}

extension TweetsViewController : TweetCellDelegate, NewTweetDelegate {
    
    func reload(tweetCell: TweetCell, at indexPath: IndexPath ) {        
    }
    
    func favorite(tweetID: String, shouldFavorite: Bool, indexPath: IndexPath) {
        twitterAPIService.favorite(tweetID: tweetID, favorite: shouldFavorite) { (tweet, error) in
            if tweet != nil {
                
                print("favorite success")
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    func retweet(tweetID: String, shouldRetweet: Bool, indexPath: IndexPath) {
        twitterAPIService.reweet(tweetID: tweetID, retweet: shouldRetweet) { (tweet, error) in
            if tweet != nil {
                
                print("retweet success")
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    func reply(forCellAt indexPath: IndexPath) {
        indexPathToReload = indexPath
        self.performSegue(withIdentifier: "ReplyFromHomeScreenSegue", sender: self)
    }
    
    
    func addNew(tweet: Tweet) {
        tweetsArray.insert(tweet, at: 0)
        tweetsTableView.reloadData()
    }
    
}
