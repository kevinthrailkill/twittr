//
//  TweetBasicCell.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/6/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//
// Basic Tweet Cell

import UIKit

class TweetBasicCell: TweetCell {

    
    @IBOutlet weak var buttonStackView: UIStackView!
    //media height constraint
    @IBOutlet weak var mediaImageViewHeightContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure() {
        super.configure()
        
        //prevents did select row from happening when selecting on stack view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStackViewTap))
        buttonStackView.addGestureRecognizer(tap)
        
        timeLabel.text = tweetForOperations.timeStamp!.ago
    }
    
    func handleStackViewTap(sender: UITapGestureRecognizer) {
        // just prevents the cell selection from happening if you press the stack view
    }
    
}



