//
//  GameCenter.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import GCHelper
import CoreData

struct GameCenter {
    
 
    func addDataToGameCenter(score: Int) {
        if score > 0 {
            GCHelper.sharedInstance.reportLeaderboardIdentifier("34jk3bk34aoir808", score: score)
        }
        
        
    }
    
}
