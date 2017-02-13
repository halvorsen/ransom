//
//  ExtensionUIViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 2/13/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit

extension UIViewController {

    var screenWidth: CGFloat {get{return UIScreen.main.bounds.width}}
    var screenHeight: CGFloat {get{return UIScreen.main.bounds.height}}
    var fontSizeMultiplier: CGFloat {get{return UIScreen.main.bounds.width / 375}}
    var topMargin: CGFloat {get{return (269/1332)*UIScreen.main.bounds.height}}
   // static var center = Int()
}

extension GameViewController {
    
    // static var center = Int()
}
