//
//  IntroViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 12/29/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class IntroViewController: UIViewController {
    
    var campaign = UIButton()
    var multiplayer = UIButton()
    var solo = UIButton()
    var campaignIAP = UIButton()
    var multiplayerIAP = UIButton()
    var soloIAP = UIButton()
    var store = UIButton()
    var menuX = UIButton()
    var restore = UIButton()
    var playerVsPlayer = UIButton()
    var aI = UIButton()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var fontSizeMultiplier = UIScreen.main.bounds.width / 375
    var seg = String()
    var tagLevelIdentifier = Int()
    var triedSolo = false
    var triedMultiplayer = false
    var triedCampaign = false
    var myLoadSaveCoreData = LoadSaveCoreData()
    var booleans = [Bool]()
    var isCampaignPurchased = false
    var isMultiplayerPurchased = false
    var isSoloPurchased = false
    var myColor = PersonalColor()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booleans = myLoadSaveCoreData.loadModesTriedData()
        triedCampaign = booleans[0]
        triedMultiplayer = booleans[1]
        triedSolo = booleans[2]
        isCampaignPurchased = myLoadSaveCoreData.isCampaignUnlocked()
        isMultiplayerPurchased = myLoadSaveCoreData.isMultiplayerUnlocked()
        isSoloPurchased = myLoadSaveCoreData.isSoloUnlocked()
        self.view.backgroundColor = myColor.background
        addButtons()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {self.view.alpha = 0.9}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if seg == "game" {
            
            let gameView: GameViewController = segue.destination as! GameViewController
            
            gameView.tagLevelIdentifier = tagLevelIdentifier
            
        } else if seg == "vs" {
            let gameView: VsViewController = segue.destination as! VsViewController
            
            gameView.tagLevelIdentifier = tagLevelIdentifier
        }
    }
    
    func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor, act:
        Selector, addSubview: Bool, alpha: Float) {
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: width*screenWidth/750, height: height*screenWidth/750)
        name.setTitle(title, for: UIControlState.normal)
        name.titleLabel!.font = UIFont(name: font, size: fontSizeMultiplier*fontSize)
        name.setTitleColor(titleColor, for: .normal)
        name.backgroundColor = bgColor
        name.layer.cornerRadius = cornerRad
        name.layer.borderWidth = boarderW
        name.alpha = CGFloat(alpha)
        name.layer.borderColor = boarderColor.cgColor
        name.addTarget(self, action: act, for: .touchUpInside)
        if addSubview {
            view.addSubview(name)
        }
    }
    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
        
        name.text = text
        name.textColor = textColor
        name.textAlignment = textAlignment
        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
        name.numberOfLines = lines
        
    }
    
    private func addButtons() {
        
        //princess
        let princessImage = UIImage(named: "Princess.png")
        let princessView = UIImageView(image: princessImage)
        princessView.alpha = 0.0
        princessView.frame = CGRect(x: (490/750)*screenWidth, y: (1110/750)*screenWidth, width: 263*screenWidth/750, height: 242*screenWidth/750)
        self.view.addSubview(princessView)
        UIView.animate(withDuration: 0.3) {
            princessView.alpha = 1.0
        }
        
        //campaign
        addButton(name: campaign, x: 59, y: 323, width: 633, height: 85, title: "Campaign", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.campaign(_:)), addSubview: true, alpha: 0.0)
        
        //multiplayer
        addButton(name: multiplayer, x: 59, y: 461, width: 633, height: 85, title: "Multiplayer", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.multiplayer(_:)), addSubview: true, alpha: 0.0)
        
        //solo
        addButton(name: solo, x: 59, y: 593, width: 633, height: 85, title: "Solo", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.solo(_:)), addSubview: true, alpha: 0.0)

        //IAP
        addButton(name: store, x: 59, y: 725, width: 633, height: 85, title: "Store", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.store(_:)), addSubview: true, alpha: 0.0)
        
        // unlock campaign
        addButton(name: campaignIAP, x: 59, y: 323, width: 633, height: 85, title: "Unlock Campaign", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.campaignIAP(_:)), addSubview: false, alpha: 0.0)
        
        // unlock multiplayer
        addButton(name: multiplayerIAP, x: 59, y: 461, width: 633, height: 85, title: "Unlock Multiplayer", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.multiplayerIAP(_:)), addSubview: false, alpha: 0.0)
        
        // unlock solo
        addButton(name: soloIAP, x: 59, y: 593, width: 633, height: 85, title: "Unlock Solo", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.soloIAP(_:)), addSubview: false, alpha: 0.0)
        
        // restore
        addButton(name: restore, x: 59, y: 725, width: 633, height: 85, title: "Restore Purchases", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.restore(_:)), addSubview: false, alpha: 0.0)

        //playerVsPlayer
        addButton(name: playerVsPlayer, x: 59, y: 323, width: 633, height: 85, title: "Player Vs Player", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.playerVsPlayer(_:)), addSubview: false, alpha: 0.0)
        playerVsPlayer.tag = 2000
        
        //aI
        addButton(name: aI, x: 59, y: 461, width: 633, height: 85, title: "Vs iPhone", font: "HelveticaNeue-Bold", fontSize: 25, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.aI(_:)), addSubview: false, alpha: 0.0)
        aI.tag = 1000
        
        //Menux Button (transition in exiting game)
        addButton(name: menuX, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(IntroViewController.menuX(_:)), addSubview: false, alpha: 0.0)
        
       
        UIView.animate(withDuration: 0.5) {
        
            self.store.alpha = 1.0
            self.solo.alpha = 1.0
            self.multiplayer.alpha = 1.0
            self.campaign.alpha = 1.0
        
        }
    }
    
    @objc private func campaign(_ button: UIButton) {
        // let hack = true
        if isCampaignPurchased || !triedCampaign {
            self.performSegue(withIdentifier: "fromIntroToMenu", sender: self)
        } else {
            campaignIAP2()
            isCampaignPurchased = myLoadSaveCoreData.isCampaignUnlocked()
            
        }
    }
    @objc private func multiplayer(_ button: UIButton) {
        // let hack = true
        if isMultiplayerPurchased || !triedMultiplayer {
            campaign.removeFromSuperview()
            solo.removeFromSuperview()
            multiplayer.removeFromSuperview()
            store.removeFromSuperview()
            view.addSubview(playerVsPlayer)
            view.addSubview(aI)
            view.addSubview(menuX)
            UIView.animate(withDuration: 0.5) {
                self.aI.alpha = 1.0
                self.playerVsPlayer.alpha = 1.0
                self.menuX.alpha = 1.0
            }
        } else {
            multiplayerIAP2()
            isMultiplayerPurchased = myLoadSaveCoreData.isMultiplayerUnlocked()
            
        }
    }
    @objc private func solo(_ button: UIButton) {
        //    let hack = true
        if isSoloPurchased || !triedSolo {
            if !triedSolo {
                tagLevelIdentifier = 100
            } else {
                tagLevelIdentifier = 101
            }
            seg = "game"
            self.performSegue(withIdentifier: "fromIntroToGame", sender: self)
        } else {
            soloIAP2()
            isSoloPurchased = myLoadSaveCoreData.isSoloUnlocked()
        }
    }
    @objc private func store(_ button: UIButton) {
        campaign.removeFromSuperview()
        solo.removeFromSuperview()
        multiplayer.removeFromSuperview()
        store.removeFromSuperview()
        view.addSubview(restore)
        view.addSubview(menuX)
        view.addSubview(multiplayerIAP)
        view.addSubview(soloIAP)
        view.addSubview(campaignIAP)
        UIView.animate(withDuration: 0.5) {
        self.restore.alpha = 1.0
        self.menuX.alpha = 1.0
        self.multiplayerIAP.alpha = 1.0
        self.soloIAP.alpha = 1.0
        self.campaignIAP.alpha = 1.0
    
        }
        
    }
    @objc private func campaignIAP(_ button: UIButton) {
        
        purchase(productId: "ransom.iap.campaign")
    }
    @objc private func soloIAP(_ button: UIButton) {
        
        purchase(productId: "ransom.iap.solo")
    }
    @objc private func multiplayerIAP(_ button: UIButton) {
        
        purchase(productId: "ransom.iap.multiplayer")
    }
    private func campaignIAP2() {
        prepareForPurchase(productId: "ransom.iap.campaign")
      
    }
    private func soloIAP2() {
        prepareForPurchase(productId: "ransom.iap.solo")
     
    }
    private func multiplayerIAP2() {
        prepareForPurchase(productId: "ransom.iap.multiplayer")
      
    }
    
    var backBlack = UILabel()
    var purcha = UIButton()
    var message = UILabel()
    var tru = UIButton()
    var product = String()
    let progressHUD = ProgressHUD(text: "Loading")
    func prepareForPurchase(productId: String) {
       // progressHUD.activityIndictor.frame.origin.y = 300*screenHeight/1334
        product = productId
        backBlack.backgroundColor = myColor.background
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(backBlack)
        view.bringSubview(toFront: backBlack)
        addButton(name: tru, x: 59, y: 461, width: 633, height: 85, title: "Try Other Modes", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.tru(_:)), addSubview: true, alpha: 0.0)
        addButton(name: purcha, x: 59, y: 323, width: 633, height: 85, title: "Purchase", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(IntroViewController.purch(_:)), addSubview: true, alpha: 0.0)
        addLabel(name: message, text: "Campaign Mode Trial Over\n Purchase for $0.99 or\n Try other game modes for free", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 18, x: 100, y: 60, width: 550, height: 200, lines: 0)
        message.alpha = 0.0
        view.addSubview(message)
        UIView.animate(withDuration: 0.5) {
            self.tru.alpha = 1.0
            self.purcha.alpha = 1.0
            self.message.alpha = 1.0
        }
        if productId == "ransom.iap.multiplayer" {
            message.text = "Multiplayer Mode Trial Over\n Purchase for $0.99 or\n Try other game modes for free"
        } else if productId == "ransom.iap.solo" {
            message.text = "Solo Mode Trial Over\n Purchase for $0.99 or\n Try other game modes for free"
        }
        
        
    }
    @objc private func tru(_ button: UIButton) {
        backBlack.removeFromSuperview()
        tru.removeFromSuperview()
        purcha.removeFromSuperview()
        message.removeFromSuperview()
        progressHUD.removeFromSuperview()
        
    }
    
    @objc private func purch(_ button: UIButton) {
        
        self.view.addSubview(progressHUD)
    
        purcha.removeFromSuperview()
        
       // self.view.backgroundColor = UIColor.black
        
        
        switch product {
        case "ransom.iap.solo": purchase(productId: product)
        case "ransom.iap.multiplayer": purchase(productId: product)
        case "ransom.iap.campaign": purchase(productId: product)
        default: break
        }
        
    }
    
    
    
    @objc private func restore(_ button: UIButton) {
        let refreshAlert = UIAlertController(title: "RESTORE", message: "Restore previously purchased items?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            SwiftyStoreKit.restorePurchases() { results in
                if results.restoreFailedProducts.count > 0 {
                    print("Restore Failed: \(results.restoreFailedProducts)")
                    SwiftyStoreKit.restorePurchases() { results in
                        if results.restoreFailedProducts.count > 0 {
                            print("Restore Failed: \(results.restoreFailedProducts)")
                        }
                        else if results.restoredProductIds.count > 0 {
                            print("Restore Success: \(results.restoredProductIds)")
                            let refreshAlert = UIAlertController(title: "Success", message: "You're all set", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            for r in results.restoredProductIds {
                                switch r {
                                case "ransom.iap.campaign":
                                    self.myLoadSaveCoreData.savePurchase(purchase: "campaign")
                                    self.isCampaignPurchased = true
                                case "ransom.iap.multiplayer":
                                    self.myLoadSaveCoreData.savePurchase(purchase: "multiplayer")
                                    self.isMultiplayerPurchased = true
                                case "ransom.iap.solo":
                                    self.myLoadSaveCoreData.savePurchase(purchase: "solo")
                                    self.isSoloPurchased = true
                                default:
                                    break
                                    
                                }
                                
                            }
                            
                        }
                        else {
                            print("Nothing to Restore")
                            
                            
                            let alert = UIAlertController(title: "RESTORE ERROR", message: "Nothing to Restore", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
                else if results.restoredProductIds.count > 0 {
                    print("Restore Success: \(results.restoredProductIds)")
                    let refreshAlert = UIAlertController(title: "Success", message: "You're all set", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    for r in results.restoredProductIds {
                        switch r {
                        case "ransom.iap.campaign":
                            self.myLoadSaveCoreData.savePurchase(purchase: "campaign")
                        case "ransom.iap.multiplayer":
                            self.myLoadSaveCoreData.savePurchase(purchase: "multiplayer")
                            
                        case "ransom.iap.solo":
                            self.myLoadSaveCoreData.savePurchase(purchase: "solo")
                        default:
                            break
                            
                        }
                        
                    }
                    
                    
                } else {
                    print("Nothing to Restore")
                    
                    let alert = UIAlertController(title: "RESTORE ERROR", message: "Nothing to Restore", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    @objc private func menuX(_ button: UIButton) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        addButtons()
    }
    @objc private func playerVsPlayer(_ button: UIButton) {
        seg = "vs"
        tagLevelIdentifier = 2000
        self.performSegue(withIdentifier: "fromIntroToVs", sender: self)
    }
    @objc private func aI(_ button: UIButton) {
        seg = "vs"
        tagLevelIdentifier = 1000
        self.performSegue(withIdentifier: "fromIntroToVs", sender: self)
    }

    func purchase(productId: String) {
        print("enter")
        var purchasebool = false
        
        SwiftyStoreKit.purchaseProduct(productId) { result in
            switch result {
            case .success( _):
                print("enter1")
                if productId == "ransom.iap.campaign" {
                    self.myLoadSaveCoreData.savePurchase(purchase: "campaign")
                    self.isCampaignPurchased = true
                    self.performSegue(withIdentifier: "fromIntroToMenu", sender: self)
                    
                }
                if productId == "ransom.iap.multiplayer" {
                    self.myLoadSaveCoreData.savePurchase(purchase: "multiplayer")
                    self.isMultiplayerPurchased = true
                    self.tru.removeFromSuperview()
                    self.view.addSubview(self.playerVsPlayer)
                    self.view.addSubview(self.aI)
                    UIView.animate(withDuration: 0.1) {self.aI.alpha = 1.0; self.playerVsPlayer.alpha = 1.0; self.tru.alpha = 0.0}
                    
                    
                }
                if productId == "ransom.iap.solo" {
                    self.myLoadSaveCoreData.savePurchase(purchase: "solo")
                    self.isSoloPurchased = true
                    self.tagLevelIdentifier = 101
                    self.seg = "game"
                    self.performSegue(withIdentifier: "fromIntroToGame", sender: self)
                    
                }
                self.progressHUD.removeFromSuperview()
            case .error(let error):
                print("error: \(error)")
                print("Purchase Failed: \(error)")
                print("enter5")
                self.progressHUD.removeFromSuperview()
            }
        }
        print("enter5")
    }
    
}
