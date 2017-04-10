//
//  LoginViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/4/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    let twitterAPIService = TwitterAPIService.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
      //  twitterAPIService = TwitterAPIService()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginToTwitter(_ sender: Any) {
        twitterAPIService.loginToTwitter() {
            (auth: Bool, error: Error?) in
            
            if auth {
                print("auth")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                
                
            }else{
                 print("not auth")
                 print(error!.localizedDescription)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
//            let tweetsNavController = segue.destination
//                as! UINavigationController
//            let tweetsViewController = tweetsNavController.viewControllers[0] as! TweetsViewController
           // tweetsViewController.twitterAPIService = twitterAPIService
        }
    }

}

