//
//  IAP.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

class IAP: LoadSaveCoreData {
   
    
    
    func purchase(productId: String) -> Bool {
            var bool = false
            SwiftyStoreKit.purchaseProduct(productId) { result in
                switch result {
                case .success( _):
                    
                    if productId == "ransom.iap.campaign" {
                        self.savePurchase(purchase: "campaign")
                        bool = true
                    }
                    if productId == "ransom.iap.multiplayer" {
                       self.savePurchase(purchase: "multiplayer")
                        bool = true
                    }
                    if productId == "ransom.iap.solo" {
                        self.savePurchase(purchase: "solo")
                        bool = true
                    }
                    
                case .error(let error):
                    print("error: \(error)")
                    print("Purchase Failed: \(error)")
                
                }
            }
       return bool
    }
    


}