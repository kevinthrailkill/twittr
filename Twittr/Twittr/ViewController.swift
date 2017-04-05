//
//  ViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/4/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var twitterAPIService : TwitterAPIService?

    override func viewDidLoad() {
        super.viewDidLoad()
        twitterAPIService = TwitterAPIService()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginToTwitter(_ sender: Any) {
        twitterAPIService?.authorizeTwitter()
    }

}

