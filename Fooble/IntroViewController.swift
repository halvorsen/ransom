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
    var playerVsPlayer = UIButton()
    var aI = UIButton()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var fontSizeMultiplier = UIScreen.main.bounds.width / 375
    var seg = String()
    var tagLevelIdentifier = Int()
    var isFirstTime = true //ADD THIS TO CORE DATA

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
//        
//        //princess
//        
//        let princessImage = UIImage(named: "Princess.png")
//        let princessView = UIImageView(image: princessImage)
//        princessView.frame = CGRect(x: (490/750)*screenWidth, y: (1098/750)*screenWidth, width: 263*screenWidth/750, height: 242*screenWidth/750)
//        self.view.addSubview(princessView)
        
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
        
        //playerVsPlayer
        
        playerVsPlayer.frame = CGRect(x: (59/750)*screenWidth, y: (323/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        playerVsPlayer.setTitle("Player Vs Player", for: UIControlState.normal)
        playerVsPlayer.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*25)
        playerVsPlayer.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        playerVsPlayer.backgroundColor = .clear
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
        aI.layer.cornerRadius = 5
        aI.layer.borderWidth = 1
        aI.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        aI.addTarget(self, action: #selector(IntroViewController.aI(_:)), for: .touchUpInside)


        
    }
    
    @objc private func campaign(_ button: UIButton) {
        self.performSegue(withIdentifier: "fromIntroToMenu", sender: self)
    }
    @objc private func multiplayer(_ button: UIButton) {
        
        campaign.removeFromSuperview()
        solo.removeFromSuperview()
        multiplayer.removeFromSuperview()
        view.addSubview(playerVsPlayer)
        view.addSubview(aI)
    }
    @objc private func solo(_ button: UIButton) {
        seg = "game"
        if isFirstTime {
        tagLevelIdentifier = 100
        } else {
           tagLevelIdentifier = 101
        }
        self.performSegue(withIdentifier: "fromIntroToGame", sender: self)
    }
    @objc private func playerVsPlayer(_ button: UIButton) {
        seg = "vs"
        tagLevelIdentifier = 300
        self.performSegue(withIdentifier: "fromIntroToVs", sender: self)
    }
    @objc private func aI(_ button: UIButton) {
        seg = "vs"
        tagLevelIdentifier = 200
        self.performSegue(withIdentifier: "fromIntroToVs", sender: self)
    }


}
