//
//  MenuViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/21/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTableView: UITableView!
    
    let menuArray = ["Home", "Mentions"]
    
    private var homeNavViewController: UIViewController!
    private var mentionsNavViewController: UIViewController!
    //private var profileViewController: ProfileViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        homeNavViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsMentionNavController")

        viewControllers.append(homeNavViewController)
        viewControllers.append(mentionsNavViewController)
        
        
        hamburgerViewController.contentViewController = homeNavViewController
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuLabel.text = menuArray[indexPath.row]
        
        return cell
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
