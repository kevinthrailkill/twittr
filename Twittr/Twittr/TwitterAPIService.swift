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

class TwitterAPIService {
    
    
    private let twitterConsumerKey = "NNBzsZMcVoSHNQOIoSvua72U2"
    private let twitterConsumerSecret = "v9G6EZiqAYxkiGSfRtx76KqHhFCw2zcwte1747qM1jqJUe1tHZ"
    private let sessionManager = SessionManager.default
    private var oauthswift: OAuth1Swift?
    
    func authorizeTwitter(){
        //Set up the OAuth with the Yelp keys
        
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
                // self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                //  self.testTwitter(oauthswift)
                print("got oauth")
                
                
                let _ = oauthswift.client.get(
                    "https://api.twitter.com/1.1/statuses/mentions_timeline.json", parameters: [:],
                    success: { response in
                        let jsonDict = try? response.jsonObject()
                        print(jsonDict as Any)
                }, failure: { error in
                    print(error)
                }
                )

                
                
        },
            failure: { error in
                print("oauth error")
                print(error.description)
        })
        
        sessionManager.adapter = OAuthSwiftRequestAdapter(oauthswift)
    }
    
    
    
}
