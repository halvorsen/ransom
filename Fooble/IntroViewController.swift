//
//  IntroViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 12/29/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//

import UIKit

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
    var isFirstTime = true //ADD THIS TO CORE DATA
    var myIAP = IAP()
    var triedSolo = false
    var triedMultiplayer = false
    var triedCampaign = false
    var myLoadSaveCoreData = LoadSaveCoreData()
    var booleans = [Bool]()
    var isCampaignPurchased = false
    var isMultiplayerPurchased = false
    var isSoloPurchased = false

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
        self.view.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        addButtons()

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
    
    private func addButtons() {
        
        //princess
        
        let princessImage = UIImage(named: "Princess.png")
        let princessView = UIImageView(image: princessImage)
        princessView.frame = CGRect(x: (490/750)*screenWidth, y: (1110/750)*screenWidth, width: 263*screenWidth/750, height: 242*screenWidth/750)
        self.view.addSubview(princessView)
        
        //campaign
        
        campaign.frame = CGRect(x: (59/750)*screenWidth, y: (323/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        campaign.setTitle("Campaign", for: UIControlState.normal)
        campaign.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        campaign.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        campaign.backgroundColor = .clear
        campaign.layer.cornerRadius = 5
        campaign.layer.borderWidth = 1
        campaign.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        campaign.addTarget(self, action: #selector(IntroViewController.campaign(_:)), for: .touchUpInside)
        self.view.addSubview(campaign)
        
        //multiplayer
        
        multiplayer.frame = CGRect(x: (59/750)*screenWidth, y: (461/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        multiplayer.setTitle("Multiplayer", for: UIControlState.normal)
        multiplayer.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        multiplayer.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        multiplayer.backgroundColor = .clear
        multiplayer.layer.cornerRadius = 5
        multiplayer.layer.borderWidth = 1
        multiplayer.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        multiplayer.addTarget(self, action: #selector(IntroViewController.multiplayer(_:)), for: .touchUpInside)
        self.view.addSubview(multiplayer)
        
        //solo
        
        solo.frame = CGRect(x: (59/750)*screenWidth, y: (593/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        solo.setTitle("Solo", for: UIControlState.normal)
        solo.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        solo.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        solo.backgroundColor = .clear
        solo.layer.cornerRadius = 5
        solo.layer.borderWidth = 1
        solo.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        solo.addTarget(self, action: #selector(IntroViewController.solo(_:)), for: .touchUpInside)
        self.view.addSubview(solo)
        
        
        //IAP
        
        store.frame = CGRect(x: (59/750)*screenWidth, y: (725/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        store.setTitle("Store", for: UIControlState.normal)
        store.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        store.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        store.backgroundColor = .clear
        store.layer.cornerRadius = 5
        store.layer.borderWidth = 1
        store.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        store.addTarget(self, action: #selector(IntroViewController.store(_:)), for: .touchUpInside)
        self.view.addSubview(store)
        
        // unlock campaign
        
        campaignIAP.frame = CGRect(x: (59/750)*screenWidth, y: (323/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        campaignIAP.setTitle("Unlock Campaign", for: UIControlState.normal)
        campaignIAP.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        campaignIAP.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        campaignIAP.backgroundColor = .clear
        campaignIAP.layer.cornerRadius = 5
        campaignIAP.layer.borderWidth = 1
        campaignIAP.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        campaignIAP.addTarget(self, action: #selector(IntroViewController.campaignIAP(_:)), for: .touchUpInside)
        
        
        // unlock multiplayer
        
        multiplayerIAP.frame = CGRect(x: (59/750)*screenWidth, y: (461/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        multiplayerIAP.setTitle("Unlock Multiplayer", for: UIControlState.normal)
        multiplayerIAP.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        multiplayerIAP.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        multiplayerIAP.backgroundColor = .clear
        multiplayerIAP.layer.cornerRadius = 5
        multiplayerIAP.layer.borderWidth = 1
        multiplayerIAP.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        multiplayerIAP.addTarget(self, action: #selector(IntroViewController.multiplayerIAP(_:)), for: .touchUpInside)

        
        // unlock solo
        
        soloIAP.frame = CGRect(x: (59/750)*screenWidth, y: (593/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        soloIAP.setTitle("Unlock Solo", for: UIControlState.normal)
        soloIAP.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        soloIAP.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        soloIAP.backgroundColor = .clear
        soloIAP.layer.cornerRadius = 5
        soloIAP.layer.borderWidth = 1
        soloIAP.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        soloIAP.addTarget(self, action: #selector(IntroViewController.soloIAP(_:)), for: .touchUpInside)

        
        
        // restore
        
        restore.frame = CGRect(x: (59/750)*screenWidth, y: (725/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        restore.setTitle("Restore Purchases", for: UIControlState.normal)
        restore.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        restore.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        restore.backgroundColor = .clear
        restore.layer.cornerRadius = 5
        restore.layer.borderWidth = 1
        restore.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        restore.addTarget(self, action: #selector(IntroViewController.restore(_:)), for: .touchUpInside)
       

        
        //playerVsPlayer
        
        playerVsPlayer.frame = CGRect(x: (59/750)*screenWidth, y: (323/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        playerVsPlayer.setTitle("Player Vs Player", for: UIControlState.normal)
        playerVsPlayer.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        playerVsPlayer.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        playerVsPlayer.backgroundColor = .clear
        playerVsPlayer.tag = 2000
        playerVsPlayer.layer.cornerRadius = 5
        playerVsPlayer.layer.borderWidth = 1
        playerVsPlayer.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        playerVsPlayer.addTarget(self, action: #selector(IntroViewController.playerVsPlayer(_:)), for: .touchUpInside)
        
        //aI
        
        aI.frame = CGRect(x: (59/750)*screenWidth, y: (461/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        aI.setTitle("AI", for: UIControlState.normal)
        aI.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        aI.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        aI.backgroundColor = .clear
        aI.tag = 1000
        aI.layer.cornerRadius = 5
        aI.layer.borderWidth = 1
        aI.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        aI.addTarget(self, action: #selector(IntroViewController.aI(_:)), for: .touchUpInside)

        //Menux Button (transition in exiting game)
        
        menuX.frame = CGRect(x: (25/750)*screenWidth, y: (25/750)*screenWidth, width: 50*screenWidth/750, height: 50*screenWidth/750)
        menuX.setTitle("X", for: UIControlState.normal)
        menuX.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        menuX.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuX.addTarget(self, action: #selector(IntroViewController.menuX(_:)), for: .touchUpInside)
        
    }
    
    @objc private func campaign(_ button: UIButton) {
        let hack = true
        if isCampaignPurchased || !triedCampaign || hack {
        self.performSegue(withIdentifier: "fromIntroToMenu", sender: self)
        } else {
            campaignIAP2()
            isCampaignPurchased = myLoadSaveCoreData.isCampaignUnlocked()
            
        }
    }
    @objc private func multiplayer(_ button: UIButton) {
        let hack = true
        if isMultiplayerPurchased || !triedMultiplayer || hack {
        campaign.removeFromSuperview()
        solo.removeFromSuperview()
        multiplayer.removeFromSuperview()
        store.removeFromSuperview()
        view.addSubview(playerVsPlayer)
        view.addSubview(aI)
        view.addSubview(menuX)
        } else {
            multiplayerIAP2()
            isMultiplayerPurchased = myLoadSaveCoreData.isMultiplayerUnlocked()
            
        }
    }
    @objc private func solo(_ button: UIButton) {
        let hack = true
        if isSoloPurchased || !triedSolo || hack {
        seg = "game"
        if isFirstTime {
        tagLevelIdentifier = 100
        } else {
           tagLevelIdentifier = 101
        }
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
        
    }
    @objc private func campaignIAP(_ button: UIButton) {
        myIAP.purchase(productId: "ransom.iap.campaign")
    }
    @objc private func soloIAP(_ button: UIButton) {
        myIAP.purchase(productId: "ransom.iap.solo")
    }
    @objc private func multiplayerIAP(_ button: UIButton) {
        myIAP.purchase(productId: "ransom.iap.multiplayer")
    }
    private func campaignIAP2() {
        myIAP.purchase(productId: "ransom.iap.campaign")
    }
    private func soloIAP2() {
        myIAP.purchase(productId: "ransom.iap.solo")
    }
    private func multiplayerIAP2() {
        myIAP.purchase(productId: "ransom.iap.multiplayer")
    }
    
    
    @objc private func restore(_ button: UIButton) {
        
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


}
