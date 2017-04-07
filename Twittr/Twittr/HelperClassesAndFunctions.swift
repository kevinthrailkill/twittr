//
//  HelperClassesAndFunctions.swift
//  Twittr
//
//  Created by Kevin Thrailkill on 4/7/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import UIKit


class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}




//Mark: Date formatting code from https://github.com/tejen/codepath-twitter

public struct humanReadableDate {
    fileprivate var base: Date
    
    init(date: Date) {
        base = date
    }
    
    public var date: (unit: String, timeSince: Double) {
        var unit = "/"
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let timeSince = Double(formatter.string(from: base))!
        formatter.dateFormat = "d/yy"
        unit += formatter.string(from: base)
        return (unit, timeSince)
    }
    
    public var datetime: String {
        let (unit, timeSince) = date
        let value = Int(timeSince)
        var l18n = "\(value)\(unit), "
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        l18n += formatter.string(from: base)
        return l18n
    }
}

// MARK: - NSDate
public extension Date {
    
    public var humanReadable: humanReadableDate {
        return humanReadableDate(date: self)
    }
    
    public var ago: String {
        var unit = "s"
        var timeSince = abs(self.timeIntervalSinceNow as Double); // in seconds
        let reductionComplete = reduced(unit, value: timeSince)
        
        while(reductionComplete != true) {
            unit = "m"
            timeSince = round(timeSince / 60)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "h"
            timeSince = round(timeSince / 60)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "d"
            timeSince = round(timeSince / 24)
            if reduced(unit, value: timeSince) { break; }
            
            unit = "w"
            timeSince = round(timeSince / 7)
            if reduced(unit, value: timeSince) { break; }
            
            (unit, timeSince) = self.humanReadable.date;   break
        }
        
        let value = Int(timeSince)
        return "\(value)\(unit)"
    }
    
    fileprivate func reduced(_ unit: String, value: Double) -> Bool {
        let value = Int(round(value))
        switch unit {
        case "s":
            return value < 60
        case "m":
            return value < 60
        case "h":
            return value < 24
        case "d":
            return value < 7
        case "w":
            return value < 4
        default: // include "w". cannot reduce weeks
            return true
        }
    }
}


