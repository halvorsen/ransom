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
    
    private func loadDataGC() -> Int {
        var maxNumber = Int()
        print("loaddata")
        var resultsScoreRequest = [AnyObject]()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let scoreRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        
        do { resultsScoreRequest = try context.fetch(scoreRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsScoreRequest.count > 0 {
            
            var array = [Int]()
            
            for result in resultsScoreRequest {
                if let score = result.value(forKey: "solo") as! Int? {
                    
                    array.append(score)
                }
                
            }
            if array.count > 0 {
                maxNumber = array.max()!
            } else { maxNumber = 0
            }
        }
        
        return maxNumber
    }
    
    private func addDataToGameCenter() {
        var highScore = Int()
        highScore = loadDataGC()
        if highScore > 0 {
            GCHelper.sharedInstance.reportLeaderboardIdentifier("Ransom High Score", score: highScore)
        }
        
        
    }
    
}
