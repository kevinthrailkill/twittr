//
//  HamburgerViewController.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/21/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeadingContraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    var menuVC: MenuViewController! {
        didSet (oldVC) {
            view.layoutIfNeeded()
            
            if oldVC != nil {
                oldVC.willMove(toParentViewController: nil)
                oldVC.view.removeFromSuperview()
                oldVC.didMove(toParentViewController: nil)
            }
            
            menuVC.willMove(toParentViewController: self)
            menuView.addSubview(menuVC.view)
            menuVC.didMove(toParentViewController: self)

            
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldVC) {
            view.layoutIfNeeded()
            
            if oldVC != nil {
                oldVC.willMove(toParentViewController: nil)
                oldVC.view.removeFromSuperview()
                oldVC.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.6, animations: {
                self.contentViewLeadingContraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = contentViewLeadingContraint.constant
        } else if sender.state == .changed {
            contentViewLeadingContraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.6, animations: {
                if velocity.x > 0 {
                    self.contentViewLeadingContraint.constant = self.view.frame.size.width - 50
                }else{
                    self.contentViewLeadingContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
            
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
