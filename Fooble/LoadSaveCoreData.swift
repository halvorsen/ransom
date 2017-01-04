//
//  LoadSaveCoreData.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct LoadSaveCoreData {
    
    private func loadLevelAccess() {
        var resultslevelRequest = [AnyObject]()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let levelRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchase")
        
        do { resultslevelRequest = try context.fetch(levelRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        var bools = [Bool]()
        var attributes = ["triple","word","score"]
        if resultslevelRequest.count > 0 {
            
            for i in 0...2 {
                print("results: \(resultslevelRequest.count)")
                for result in resultslevelRequest {
                    if let bo = result.value(forKey: attributes[i]) as! Bool? {
                        print("bo: \(bo)")
                        bools.append(bo)
                        for boo in bools {
                            
                            if boo {
                                switch i {
                                case 0:
                                    unlockedTriple = true
                                case 1:
                                    unlockedWord = true
                                default:
                                    unlockedScore = true
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    
    
    private func loadData() -> Bool {
        
        var isGameInProgress = false
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let gameRequest = NSFetchRequest<NSFetchRequestResult>(entityName: gameData)
        
        do { resultsGameRequest = try context.fetch(gameRequest)
            didDataLoad = true} catch  {
                
                do { resultsGameRequest = try context.fetch(gameRequest)
                    didDataLoad = true} catch  {
                        print("error")
                }
                
        }
        
        if resultsGameRequest.count > 0 {
            
            list = resultsGameRequest.last?.value(forKeyPath: "list") as! [String]
            done = resultsGameRequest.last?.value(forKeyPath: "bool") as! [Int]
            index = resultsGameRequest.last?.value(forKeyPath: "index") as! [Int]
            score = resultsGameRequest.last?.value(forKeyPath: "score") as! Int
            time = resultsGameRequest.last?.value(forKeyPath: "time") as! Int
            print("segue list")
            print(list)
            print(done)
            print(index)
            print(score)
            print(time)
            isGameInProgress = true
            
        }
        
        
        return isGameInProgress
        
    }
    
    
}
