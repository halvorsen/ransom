//
//  LoadSaveCoreData.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LoadSaveCoreData {
    
    func saveScore(score: Int) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context)
        entity.setValue(score, forKey: "solo")
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveDemo(mode: String) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let demo = NSEntityDescription.insertNewObject(forEntityName: mode, into: context)
        demo.setValue(true, forKey: "tried")
        do { try context.save() } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveLevel(tagLevelIdentifier: Int) {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let newLevel = NSEntityDescription.insertNewObject(forEntityName: "Levels", into: context)
        newLevel.setValue(tagLevelIdentifier, forKey: "name")
        do { try context.save() } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    func savePurchase(purchase: String) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Purchase", into: context)
        entity.setValue(true, forKey: purchase)
        do {
            try context.save()
        } catch {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func loadModesTriedData() -> [Bool] {
        var resultsCampaignBool = [AnyObject]()
        var resultsMultiplayerBool = [AnyObject]()
        var resultsSoloBool = [AnyObject]()
        var soloBool = false
        var multiplayerBool = false
        var campaignBool = false
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let requestCampaignBool = NSFetchRequest<NSFetchRequestResult>(entityName: "Campaign")
        
        do { resultsCampaignBool = try context.fetch(requestCampaignBool) } catch  {
            print("Could not cache the response \(error)")
        }
        let requestMultiplayerBool = NSFetchRequest<NSFetchRequestResult>(entityName: "Multiplayer")
        
        do { resultsMultiplayerBool = try context.fetch(requestMultiplayerBool) } catch  {
            print("Could not cache the response \(error)")
        }
        let requestSoloBool = NSFetchRequest<NSFetchRequestResult>(entityName: "Solo")
        
        do { resultsSoloBool = try context.fetch(requestSoloBool) } catch  {
            print("Could not cache the response \(error)")
        }

        if (resultsCampaignBool.count > 0)  {campaignBool = true}
        if (resultsMultiplayerBool.count > 1)  {multiplayerBool = true}
        if (resultsSoloBool.count > 0)  {soloBool = true}

        return [campaignBool,multiplayerBool,soloBool]
        
    }
    
    func loadDataForLevelsPassed() -> [Int] {
        var resultsLevelsPassedMenu = [AnyObject]()
        var resultsLevelsPassed = [Int]()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let requestLevelsPassed = NSFetchRequest<NSFetchRequestResult>(entityName: "Levels")
        
        do { resultsLevelsPassedMenu = try context.fetch(requestLevelsPassed) } catch  {
            print("Could not cache the response \(error)")
        }
        if (resultsLevelsPassedMenu.count > 0)  {
            
            for i in 0..<resultsLevelsPassedMenu.count {
                resultsLevelsPassed.append((resultsLevelsPassedMenu[i].value(forKeyPath: "name") as? Int)!)
            }
        }
        
        return resultsLevelsPassed
        
    }
    
    func isCampaignUnlocked() -> Bool {
        var bool = Bool()
        bool = loadLevelAccess(mode: "campaign")
        return bool
    }
    func isMultiplayerUnlocked() -> Bool {
        var bool = Bool()
        bool = loadLevelAccess(mode: "multiplayer")
        return bool
    }
    func isSoloUnlocked() -> Bool {
        var bool = Bool()
        bool = loadLevelAccess(mode: "solo")
        return bool
    }
    
    func loadLevelAccess(mode: String) -> Bool {
        var resultslevelRequest = [AnyObject]()
        var unlockedCampaign = false
        var unlockedMultiplayer = false
        var unlockedSolo = false
        var booleanOperator = Bool()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        let levelRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchase")
        
        do { resultslevelRequest = try context.fetch(levelRequest) } catch  {
            print("Could not cache the response \(error)")
        }
        var bools = [Bool]()
        var attributes = ["campaign","multiplayer","solo"]
        if resultslevelRequest.count > 0 {
            
            for i in 0...2 {
                print("results: \(resultslevelRequest.count)")
                for result in resultslevelRequest {
                    if let bo = result.value(forKey: attributes[i]) as! Bool? {
                        
                        bools.append(bo)
                        for boo in bools {
                            
                            if boo {
                                switch i {
                                case 0:
                                    unlockedCampaign = true
                                case 1:
                                    unlockedMultiplayer = true
                                default:
                                    unlockedSolo = true
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
        }
        switch mode {
        case "campaign": booleanOperator = unlockedCampaign
        case "multiplayer": booleanOperator = unlockedMultiplayer
        case "solo": booleanOperator = unlockedSolo
        default: break
        }
        return booleanOperator
    }
    
    
}
