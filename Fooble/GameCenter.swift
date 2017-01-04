//
//  GameCenter.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct GameCenter {
    
    private func loadDataGC() {
        print("loaddata")
        var resultsScoreRequest = [AnyObject]()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let scoreRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        
        do { resultsScoreRequest = try context.fetch(scoreRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        
        if resultsScoreRequest.count > 0 {
            
            for i in 0...8 {
                
                //   var score: Int? = 0
                var maxNumber: Int
                for result in resultsScoreRequest {
                    if let score = result.value(forKey: levels[i]) as! Int? {
                        
                        array.append(score)
                    }
                    
                }
                if array.count > 0 {
                    maxNumber = array.max()!
                    annotations[i+9] = String(maxNumber)
                    print("maxscore")
                    print(maxNumber)
                    print("i: \(i)")
                    highScores[i] = maxNumber
                }
                array.removeAll()
                
            }
        }
    }
    
    private func addDataToGameCenter() {
        
        for i in 0...8 {
            if highScores[i] > 0 {
                GCHelper.sharedInstance.reportLeaderboardIdentifier(annotations[i], score: highScores[i])
            }
        }
        
    }
    
}
