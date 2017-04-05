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
    
    
    //OAuth Info
    private let twitterConsumerKey = "NNBzsZMcVoSHNQOIoSvua72U2"
    private let twitterConsumerSecret = "v9G6EZiqAYxkiGSfRtx76KqHhFCw2zcwte1747qM1jqJUe1tHZ"
    private let sessionManager = SessionManager.default
    private var oauthswift: OAuth1Swift?
    var isAuthorized : Bool = false
    
    //URLS
    private var verifyCredentialURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
    private var getHomeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    
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
                keychain.set("the_token_key", forKey: credential.oauthToken)
                keychain.set("the_secret_token_key", forKey: credential.oauthTokenSecret)
                
                
//                let keychain = KeychainPreferences.sharedInstance
//                // each element
//                keychain["the_token_key"] = credential.oauthToken
//                keychain["the_secret_token_key"] = credential.oauthTokenSecret
                
                
                
                
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
    
    func getHomeTimeline(completion: @escaping ([Tweet]?, Error?) -> ()){
        sessionManager.request(getHomeTimelineURL, method: .get)
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
