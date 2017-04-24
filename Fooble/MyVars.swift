//
//  MyVars.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 2/6/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import UIKit


public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

struct PersonalColor {
    
    //pink
    var pink = UIColor(red: 249/255, green: 22/255, blue: 109/255, alpha: 1.0)
    
    //yellow
    var yellow = UIColor(red: 251/255, green: 214/255, blue: 50/255, alpha: 1.0)
    
    //blue
    var blue = UIColor(red: 80/255, green: 189/255, blue: 252/255, alpha: 1.0)
    
    //white
    var white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    //offwhite
    var offWhite = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    
    //background
    var background = UIColor(red: 24/255, green: 23/255, blue: 67/255, alpha: 1.0)
    
    //red
    var red = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0)
    
}

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}





