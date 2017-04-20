//
//  TwitterAPIService.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/4/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//


import Foundation
import Alamofire
import UnboxedAlamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainSwift

class TwitterAPIService {
    
    
    
    static let sharedInstance = TwitterAPIService()
    
    
    //OAuth Info
    private let twitterConsumerKey = "NNBzsZMcVoSHNQOIoSvua72U2"
    private let twitterConsumerSecret = "v9G6EZiqAYxkiGSfRtx76KqHhFCw2zcwte1747qM1jqJUe1tHZ"
    private let sessionManager = SessionManager.default
    private var oauthswift: OAuth1Swift?
    var isAuthorized : Bool = false
    
    //URLS
    private var verifyCredentialURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
    private var getHomeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    private var retweetURL = "https://api.twitter.com/1.1/statuses/retweet/"
    private var unRetweetURL = "https://api.twitter.com/1.1/statuses/destroy/"
    private var favoriteURL = "https://api.twitter.com/1.1/favorites/create.json"
    private var unFavoriteURL = "https://api.twitter.com/1.1/favorites/destroy.json"
    private var statusURL = "https://api.twitter.com/1.1/statuses/show/"
    private var updateStatusURL = "https://api.twitter.com/1.1/statuses/update.json"
    private var getUserTimelineURL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    private var getMentionsTimelineURL = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
    
    
    
    
    /// Function to bypass login screen and create oauth session with user credentials
    func byPassLoginScreen(){
        
        let oauthswift = OAuth1Swift(
            consumerKey: twitterConsumerKey,
            consumerSecret: twitterConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token")
        
        self.oauthswift = oauthswift
        
        let keychain = KeychainSwift()
        
        oauthswift.client.credential.oauthToken = keychain.get("the_token_key")!
        oauthswift.client.credential.oauthTokenSecret = keychain.get("the_secret_token_key")!
        
        
        isAuthorized = true
        sessionManager.adapter = OAuthSwiftRequestAdapter(oauthswift)
        
    }
    
    
    /// Logs the user out and clears the saved credentials
    func logout() {
        User.currentUser = nil
        let keychain = KeychainSwift()
        keychain.delete("the_token_key")
        keychain.delete("the_secret_token_key")
        
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)

    }
    
    
    
    /// Logs you in with your twitter credentials and creates a oauth session
    ///
    /// - Parameter completion: on success moves you to the home page
    func loginToTwitter(completion: @escaping (Bool, Error?) -> ()){
        
        let oauthswift = OAuth1Swift(
            consumerKey: twitterConsumerKey,
            consumerSecret: twitterConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token")
        
        self.oauthswift = oauthswift
        
        oauthswift.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "http://oauthswift.herokuapp.com/callback/twitter")!,
            success: { credential, response, parameters in
                print("got oauth")
                self.isAuthorized = true
                self.sessionManager.adapter = OAuthSwiftRequestAdapter(oauthswift)
                
                print(credential)
                
                let keychain = KeychainSwift()
                
                keychain.set(credential.oauthToken, forKey: "the_token_key")
                keychain.set(credential.oauthTokenSecret, forKey: "the_secret_token_key")
                
                self.getUser() {
                    (user: User?, error: Error?) in
                    if let user = user {
                        print(user)
                        User.currentUser = user
                    }else{
                        print(error!.localizedDescription)
                    }
                }
                
                completion(true, nil)
        },
            failure: { error in
                print("oauth error")
                print(error.description)
                self.isAuthorized = false
                completion(self.isAuthorized, error)
                
        })
    }
    
    
    
    /// Gets the user from the twitter api
    ///
    /// - Parameter completion: if success, returns the user
    func getUser(completion: @escaping (User?, Error?) -> ()){
        sessionManager.request(verifyCredentialURL, method: .get)
            .responseObject { (response: DataResponse<User>) in
                switch response.result {
                case .success(let value):
                    let user = value
                    completion(user, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    
    
    /// Gets the Home Timeline for the user
    ///
    /// - Parameters:
    ///   - maxID: The id of the last tweet that we have. Used to get older tweets
    ///   - completion: if good, return tweets to display
    func getHomeTimeline(maxID: String?, completion: @escaping ([Tweet]?, Error?) -> ()){
        
        var params: [String : AnyObject] = ["count" : 20 as AnyObject]
        
        if let id = maxID {
            params["max_id"] = id as AnyObject
        }
        
        sessionManager.request(getHomeTimelineURL, method: .get, parameters: params, encoding: URLEncoding.queryString)
            .responseArray { (response: DataResponse<[Tweet]>) in
                switch response.result {
                case .success(let value):
                    let tweets = value
                    completion(tweets, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    
    
    /// Retweets or unretweets a tweet
    ///
    /// - Parameters:
    ///   - tweetID: the tweet id of the tweet
    ///   - retweet: whether or not to retweet or unretweet
    ///   - completion: on success, return the tweet that the action is performed on
    func reweet(tweetID: String, retweet: Bool, completion: @escaping (Tweet?, Error?) -> ()) {
        
        if !retweet {
            
            //un retweet
            print(tweetID)
            sessionManager.request(statusURL + tweetID + ".json?include_my_retweet=1", method: .get)
                .responseObject { (response: DataResponse<Tweet>) in
                    switch response.result {
                    case .success(let value):
                        let tweet = value
                        
                        let retweetID = tweet.currentUserRetweet!.id_str
                        
                        self.sessionManager.request(self.unRetweetURL + retweetID! + ".json", method: .post)
                            .responseObject { (response: DataResponse<Tweet>) in
                                switch response.result {
                                case .success(let value):
                                    let tweet = value
                                    completion(tweet, nil)
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    completion(nil, error)
                                }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
            }
        }else{
            sessionManager.request(retweetURL + tweetID + ".json", method: .post)
                .responseObject { (response: DataResponse<Tweet>) in
                    switch response.result {
                    case .success(let value):
                        let tweet = value
                        completion(tweet, nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
            }
        }
    }
    
    
    /// Favorites or unfavorites a tweet
    ///
    /// - Parameters:
    ///   - tweetID: the tweet id of the tweet
    ///   - favorite: whether or not to favorite or not
    ///   - completion: on success, return the tweet that the action is performed on
    func favorite(tweetID: String, favorite: Bool, completion: @escaping (Tweet?, Error?) -> ()) {
        
        let params = ["id" : tweetID]
        
        var endpoint : String
        
        if favorite {
            endpoint = favoriteURL
        }else{
            endpoint = unFavoriteURL
        }
        
        sessionManager.request(endpoint, method: .post, parameters: params, encoding: URLEncoding.queryString)
            .responseObject { (response: DataResponse<Tweet>) in
                switch response.result {
                case .success(let value):
                    let tweet = value
                    completion(tweet, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    
    
    /// Publishes a new tweet
    ///
    /// - Parameters:
    ///   - tweetBody: the tweet
    ///   - replyToStayusID: if a reply, a reply id of the tweet
    ///   - completion: returns the new tweet created
    func publish(tweetBody: String, replyToStatusID: String?, completion: @escaping (Tweet?, Error?) -> ()) {
        
        var params = ["status" : tweetBody]
        
        if let replyId = replyToStatusID {
            params["in_reply_to_status_id"] = replyId
        }
        
        sessionManager.request(updateStatusURL, method: .post, parameters: params, encoding: URLEncoding.queryString)
            .responseObject { (response: DataResponse<Tweet>) in
                switch response.result {
                case .success(let value):
                    let tweet = value
                    completion(tweet, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
                
        }
        
    }
    
    func getUserTimeline(userID: Int, maxID: String?, completion: @escaping ([Tweet]?, Error?) -> ()) {
        
        var params: [String : AnyObject] = ["count" : 20 as AnyObject, "user_id" : userID as AnyObject]
        
        if let id = maxID {
            params["max_id"] = id as AnyObject
        }
        
        sessionManager.request(getUserTimelineURL, method: .get, parameters: params, encoding: URLEncoding.queryString)
            .responseArray { (response: DataResponse<[Tweet]>) in
                switch response.result {
                case .success(let value):
                    let tweets = value
                    completion(tweets, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    
    func getMentionsTimeline(maxID: String?, completion: @escaping ([Tweet]?, Error?) -> ()){
        
        var params: [String : AnyObject] = ["count" : 20 as AnyObject]
        
        if let id = maxID {
            params["max_id"] = id as AnyObject
        }
        
        sessionManager.request(getMentionsTimelineURL, method: .get, parameters: params, encoding: URLEncoding.queryString)
            .responseArray { (response: DataResponse<[Tweet]>) in
                switch response.result {
                case .success(let value):
                    let tweets = value
                    completion(tweets, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    
}
