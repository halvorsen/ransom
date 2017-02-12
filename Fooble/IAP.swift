//
//  IAP.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//
//
//import Foundation
//import StoreKit
//import SwiftyStoreKit
//
//class IAP {
//    
//    func purchase(productId: String) {
//        print("enter")
//        var purchasebool = false
//      
//        SwiftyStoreKit.purchaseProduct(productId) { result in
//            switch result {
//            case .success( _):
//                print("enter1")
//                if productId == "ransom.iap.campaign" {
//                    myLoadSaveCoreData.savePurchase(purchase: "campaign")
//                    self.purchasebool = true
//                    print("enter2")
//                    
//                }
//                if productId == "ransom.iap.multiplayer" {
//                    myLoadSaveCoreData.savePurchase(purchase: "multiplayer")
//                    self.purchasebool = true
//                    print("enter3")
//                    
//                }
//                if productId == "ransom.iap.solo" {
//                    myLoadSaveCoreData.savePurchase(purchase: "solo")
//                    self.purchasebool = true
//                    print("enter4")
//                    
//                }
//           
//            case .error(let error):
//                print("error: \(error)")
//                print("Purchase Failed: \(error)")
//                print("enter5")
//          
//            }
//        }
//        print("enter5")
//    }
//    
//    
//    
//}
