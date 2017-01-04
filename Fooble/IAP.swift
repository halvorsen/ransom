//
//  IAP.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct IAP {
   
    //IAP
    
    func purchaseRetry(productId: String) {
        
        let refreshAlert = UIAlertController(title: "PURCHASE FAILED", message: "Retry?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            SwiftyStoreKit.purchaseProduct(productId) { result in
                switch result {
                case .success( _):
                    
                    if productId == "pairings.iap.scoreboard" {
                        
                        self.savePurchase()
                        
                    }
                    if productId == "pairings.iap.advancedLevel1" {
                        self.savePurchase()
                        
                    }
                    if productId == "pairings.iap.advancedLevel2" {
                        self.savePurchase()
                        
                    }
                    
                case .error(let error):
                    print("error: \(error)")
                    print("Purchase Failed: \(error)")
                    self.purchaseRetry(productId: productId)
                }            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func purchase(productId: String) {
        var title = String()
        var message = String()
        if productId == "pairings.iap.scoreboard" {
            
            title = "ADD SCOREBOARD"
            message = "Track Highscores?"
        }
        if productId == "pairings.iap.advancedLevel1" {
            
            title = "BUY FOOLISH LEVEL"
            message = "Unlock Level?"
        }
        if productId == "pairings.iap.advancedLevel2" {
            
            
            title = "BUY 3 MORE LEVELS"
            message = "Unlock triples levels?"
        }
        
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            SwiftyStoreKit.purchaseProduct(productId) { result in
                switch result {
                case .success( _):
                    
                    if productId == "pairings.iap.scoreboard" {
                        self.savePurchase()
                        
                    }
                    if productId == "pairings.iap.advancedLevel1" {
                        self.savePurchase()
                        
                    }
                    if productId == "pairings.iap.advancedLevel2" {
                        self.savePurchase()
                        
                    }
                    
                case .error(let error):
                    print("error: \(error)")
                    print("Purchase Failed: \(error)")
                    self.purchaseRetry(productId: productId)
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }

    
    
}
