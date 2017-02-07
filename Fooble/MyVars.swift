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
    var pink = UIColor(red: 255/255, green: 6/255, blue: 107/255, alpha: 1.0)
    
    //yellow
    var yellow = UIColor(red: 252/255, green: 216/255, blue: 6/255, alpha: 1.0)
    
    //blue
    var blue = UIColor(red: 73/255, green: 188/255, blue: 255/255, alpha: 1.0)
    
    //white
    var white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    //offwhite
    var offWhite = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    
    //background
    var background = UIColor(red: 24/255, green: 23/255, blue: 67/255, alpha: 0.9)
    
    //red
    var red = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0)
    
}





