//
//  GameViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 12/28/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//

import UIKit
import GCHelper


class GameViewController: UIViewController {
    var seg = "nothing"
    var center = Int()
    var centerPoint = CGPoint()
    var passedLevel = Bool()
    var panTouchLocation = CGPoint()
    var locationOfBeganPan = CGPoint()
    var locationOfEndPan = CGPoint()
    var tagLevelIdentifier = Int()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let topMargin = (269/1332)*UIScreen.main.bounds.height
    var frontMargin = CGFloat()//(35/750)*screenWidth
    var annotations = [UILabel]()
    var goalScoreInt = Int() {didSet{goalScoreString = String(goalScoreInt)}}
    var goalScoreString = String()
    var currentScoreString = String()
    var currentScoreInt = Int() {didSet{currentScoreString = String(currentScoreInt)}}
    let dotSize = (1/16)*UIScreen.main.bounds.width
    let score = UILabel()
    let hint = UIButton()
    let exit = UIButton()
    let leaderboard = UIButton()
    let scoreFlash = UILabel()
    var displayLayers = [CAShapeLayer]()
    var shapeLayers = [CAShapeLayer?]()
    var shapeLayers2 = [CAShapeLayer]()
    let restart = UIButton()
    let sequence = UIButton()
    let sequences = UILabel()
    let back = UIButton()
    let exitSequences = UIButton()
    let showList = UIButton()
    let yellowScore = UILabel()
    let gameCenter = UIButton()
    let redScore = UILabel()
    var hintDisplay = [CAShapeLayer]()
    var hintNumbersAsStrings = [String]()
    var hintNumberLabels = [UILabel]()
    let finishMessage = UILabel()
    var questButtons = [UIButton]()
    let menuX = UIButton()
    let menuX2 = UIButton()
    let menuBox = UIButton()
    let continueToPlay = UIButton()
    let tutorialAnnotation = UILabel()
    let tutorialAnnotation2 = UILabel()
    let tutorialAnnotation3 = UILabel()
    let sequenceRowOne = UILabel()
    let sequenceRowTwo = UILabel()
    let okay = UIButton()
    let dotNumbersAsStrings = [String]()
    var dotLabels = [UILabel?]()
    var displayLabels = [UILabel]()
    var additionalScoreString = String()
    var additionalScoreInt = Int() {didSet{additionalScoreString = String(additionalScoreInt)}}
    var deck = [Int?]()
    var myShuffleAndDeal = ShuffleAndDeal()
    let mySelection = Selection()
    let myCalculator = Calculator()
    let myNarrative = Narrative()
    let myLoadSaveCoreData = LoadSaveCoreData()
    let myGameCenter = GameCenter()
    var myAllPossibilities = AllPossibilities()
    var count: Int = 0
    var lastCardDisplayed = Int()
    var firstIndexDisplayed = Int()
    var hand = [Int]()
    var handIndexes = [Int]()
    var additionalPoints = Int()
    var trackerSum: Int = 0
    var trackerSumPrior: Int = 0
    var iReverse = [Int]()
    var isDropInProgress = false
    var bool = true
    var backBlack = UILabel()
    var highestHand = [1,1,1,1,1]
    var _highestHand = [1,1,1,1,1]
    var highestSoFar = 1
    var questString = String()
    var iWantToFinish = false
    let imageView = UIImageView()
    var imageViewGlobal = UIImageView()
    var shuffled = [Int]()
    var allNumbers = [Int]()
    var pan = UIPanGestureRecognizer()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.respondToPanGesture(_:)))
        self.view.addGestureRecognizer(pan)
        currentScoreInt = 0
        goalScoreInt = 20000
        for i in 0..<60 {
            
            iReverse.append(59-i)
            
        }
        
        addButtons()
        
        
        for i in 0..<84 {
            allNumbers.append(i)
        }
        for _ in 0..<67 {
            let randomNumber = Int(arc4random_uniform(UInt32(allNumbers.count)))
            if let index = allNumbers.index(of: allNumbers[randomNumber]) {
                shuffled.append(allNumbers[randomNumber])
                allNumbers.remove(at:index)
            }
        }
        deck = shuffled
        lastCardDisplayed = 999
        populateDots()
        
        
        view.addSubview(menuX)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("tagLevelIdentifier: \(tagLevelIdentifier)")
        if tagLevelIdentifier > 99 {
            GCHelper.sharedInstance.authenticateLocalUser()
        }
        
    }
    
    private func populateDots() {
        
        lastCardDisplayed = 999
        for i in 0..<67 {
            
            
            
            switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
            case .blue: //blue
                shapeLayers[i]!.strokeColor = UIColor(red: 60/255, green: 54/255, blue: 116/255, alpha: 1.0).cgColor
                
            case .green: //green
                shapeLayers[i]!.strokeColor = UIColor(red: 69/255, green: 125/255, blue: 59/255, alpha: 1.0).cgColor
                
            case .yellow: //yellow
                shapeLayers[i]!.strokeColor = UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0).cgColor
                
            case .red: //red
                shapeLayers[i]!.strokeColor = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0).cgColor
                
            }
            let linewidth = 2.0*screenWidth/750
            shapeLayers[i]!.lineWidth = linewidth
            dotLabels[i]!.text = String(deck[i]!%7 + 1)
            view.layer.addSublayer(shapeLayers[i]!)
            self.view.addSubview(dotLabels[i]!)
        }
        if tagLevelIdentifier == 100 {
            displayTutorial()
            menuX.removeFromSuperview()
        } else if tagLevelIdentifier == 1 {
            displayTutorialForCampaign()
        } else {
            view.addSubview(menuX)
        }
    }
    
    
    var futureIndexes = [Int]()
    var priorIndex = Int()
    var lastIndex = Int()
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if tagLevelIdentifier == 1 {
            if tutorialAnnotation3.isDescendant(of: view) {
                tutorialAnnotation3.removeFromSuperview()
            }
        }
        
        if gesture.state == UIGestureRecognizerState.began {
            hand.removeAll()
            handIndexes.removeAll()
            for i in 0...4 {
                if displayLabels[i].isDescendant(of: self.view) {
                    displayLabels[i].removeFromSuperview()
                    displayLayers[i].removeFromSuperlayer()
                }
            }
            let began = gesture.location(in: view)
            
            for i in 0..<67 {
                if shapeLayers2[i].path!.contains(began) {
                    if shapeLayers[i] != nil && deck[i] != nil { //new
                        
                        switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
                        case .blue: //blue
                            displayLayers[0].strokeColor = UIColor(red: 60/255, green: 54/255, blue: 116/255, alpha: 1.0).cgColor
                        case .green: //green
                            displayLayers[0].strokeColor = UIColor(red: 69/255, green: 125/255, blue: 59/255, alpha: 1.0).cgColor
                        case .yellow: //yellow
                            displayLayers[0].strokeColor = UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0).cgColor
                        case .red: //red
                            displayLayers[0].strokeColor = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0).cgColor
                            
                        }
                        
                        displayLabels[0].text = String(deck[i]!%7 + 1)
                        lastIndex = i
                        
                        futureIndexes = mySelection.selectableIndexesWithOneAlreadySelected(first: i)
                        
                        view.layer.addSublayer(displayLayers[0])
                        self.view.addSubview(displayLabels[0])
                        lastCardDisplayed = deck[i]!
                        firstIndexDisplayed = i
                        count = 1
                        hand.append(deck[i]!)
                        handIndexes.append(i)
                    }
                }
            }
        }
        outerloop: if gesture.state == UIGestureRecognizerState.changed {
            let locationOfPan = gesture.location(in: view)
            if count > 1 {
                if shapeLayers2[firstIndexDisplayed].path!.contains(locationOfPan){
                    for i in 0...4 {
                        if displayLabels[i].isDescendant(of: self.view) {
                            displayLabels[i].removeFromSuperview()
                            displayLayers[i].removeFromSuperlayer()
                            handIndexes.removeAll()
                            hand.removeAll() //new
                            futureIndexes.removeAll()
                            count = 0
                        }
                    }
                    
                    break outerloop
                }
            }
            
            if count < 5 && count > 0 { //new
                if self.displayLabels[0].isDescendant(of: self.view) {
                    
                    
                    for i in futureIndexes {
                        
                        var futureRow = mySelection.thisRow(index: i)
                        let lastRow = mySelection.thisRow(index: lastIndex)
                        switch lastIndex {
                        case 6,14,21,29,36,44,51,59:
                            if i == lastIndex + 1 {
                                futureRow = lastRow + 2
                            }
                        case 7,15,22,30,37,45,52,60:
                            if i == lastIndex - 1 {
                                futureRow = lastRow + 2
                            }
                        default: break
                        }
                        if shapeLayers2[i].path!.contains(locationOfPan) && dotLabels[i]!.isDescendant(of: self.view) && (lastCardDisplayed != deck[i]!) {
                            
                            if futureRow == lastRow - 1 || futureRow == lastRow + 1 || futureRow == lastRow {
                                
                                
                                switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
                                case .blue: //blue
                                    displayLayers[count].strokeColor = UIColor(red: 60/255, green: 54/255, blue: 116/255, alpha: 1.0).cgColor
                                case .green: //green
                                    displayLayers[count].strokeColor = UIColor(red: 69/255, green: 125/255, blue: 59/255, alpha: 1.0).cgColor
                                case .yellow: //yellow
                                    displayLayers[count].strokeColor = UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0).cgColor
                                case .red: //red
                                    displayLayers[count].strokeColor = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0).cgColor
                                }
                                
                                displayLabels[count].text = String(deck[i]!%7 + 1)
                                lastCardDisplayed = deck[i]!
                                priorIndex = lastIndex
                                lastIndex = i
                                var potentialFutureIndex = Int()
                                potentialFutureIndex = mySelection.linearCheckForNumberAfterLast(last: i, prior: priorIndex)
                                
                                if potentialFutureIndex > -1 && potentialFutureIndex < 67 {
                                    if dotLabels[potentialFutureIndex] != nil {
                                        if dotLabels[potentialFutureIndex]!.isDescendant(of: self.view) {
                                            
                                            futureIndexes.removeAll()
                                            futureIndexes.append(potentialFutureIndex)
                                        }
                                    }
                                }
                                
                                view.layer.addSublayer(displayLayers[count])
                                self.view.addSubview(displayLabels[count])
                                hand.append(deck[i]!)
                                handIndexes.append(i)
                                count += 1
                            }
                        }
                    }
                }
            }
        }
        if gesture.state == UIGestureRecognizerState.ended {
            
 
            hand = myCalculator.reorderHand(hand: hand)
        
            additionalScoreInt = myCalculator.pointAmount(hand: hand)
            questString = myCalculator.questString(hand: myCalculator.reorderHand(hand: hand))
            
            if additionalScoreInt != 0 {
                view.removeGestureRecognizer(pan as UIGestureRecognizer)
               
                for i in handIndexes {
                    dotLabels[i]!.removeFromSuperview()
                    deck[i] = nil
                    shapeLayers[i]!.removeFromSuperlayer()
                    shapeLayers[i] = nil
                }
                
                for i in 0...4 {
                    if displayLabels[i].isDescendant(of: self.view) {
                        displayLabels[i].removeFromSuperview()
                        displayLayers[i].removeFromSuperlayer()
                    }
                }
                
                
                
                if tagLevelIdentifier > 99 {
                    scoreFlash.text = additionalScoreString
                } else {
                    scoreFlash.text = questString
                }
                scoreFlash.alpha = 0
                self.view.addSubview(scoreFlash)
                UIView.animate(withDuration: 0.5, animations: {
                    self.scoreFlash.alpha = 1.0
                })
                _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(GameViewController.scoreFlashEnd), userInfo: nil, repeats: false)
                if additionalScoreInt > highestSoFar {
                    highestHand = _highestHand
                    highestSoFar = additionalScoreInt
                }
                currentScoreInt += additionalScoreInt
                dropRight(currentDeck: deck)
                
                delay(bySeconds: 0.5) {
                    self.dropLeft(currentDeck: self.deck)
                }
                
                
                
            }
        }
        
    }
    
    
    
    private func dropLeft(currentDeck: [Int?]) {
        while isDropInProgress {
            print("dropinprogress")
        }
        isDropInProgress = true
        delay(bySeconds: 0.2) { while self.trackerSum != self.trackerSumPrior || self.bool {
            print("enteredWhileLoop")
            self.trackerSumPrior = self.trackerSum
            //
            for i in self.iReverse {
                
                if i != 7 && i != 22 && i != 37 && i != 52 {
                    
                    if self.deck[i] != nil {
                        
                        if self.deck[i+7] == nil {
                            UIView.animate(withDuration: 0.18, animations: {
                                self.dotLabels[i]!.frame.origin.x -= self.dotSize
                            })
                            UIView.animate(withDuration: 0.18, animations: {
                                self.dotLabels[i]!.frame.origin.y += 2*self.dotSize
                            })
                            
                            
                            self.dotLabels[i+7] = self.dotLabels[i]!
                            self.dotLabels[i] = nil
                            
                            
                            CATransaction.begin()
                            CATransaction.setAnimationDuration(0.18)
                            self.shapeLayers[i]!.frame.origin.x -= self.dotSize
                            CATransaction.commit()
                            
                            CATransaction.begin()
                            CATransaction.setAnimationDuration(0.18)
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
                            CATransaction.commit()
                            
                            
                            self.shapeLayers[i+7] = self.shapeLayers[i]!
                            self.shapeLayers[i] = nil
                            self.deck[i+7] = self.deck[i]
                            self.deck[i] = nil
                            
                            self.trackerSum += 1
                            
                            //       }
                        }
                    }
                }
            }
            
            
            self.bool = false
            }
        }
        isDropInProgress = false
        bool = true
        self.view.addGestureRecognizer(pan)
        delay(bySeconds: 0.6) {
        if self.dotLabels[30] == nil && self.dotLabels[31] == nil {
            let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)}
        
        if !self.myAllPossibilities.stopEverything {
            self.noMoreMoves()
        }
        }
    }
    
    private func dropRight(currentDeck: [Int?]) {
        while isDropInProgress {
            print("dropinprogess")
        }
        isDropInProgress = true
        
        delay(bySeconds: 0.2) {  while self.trackerSum != self.trackerSumPrior || self.bool {
            
            self.trackerSumPrior = self.trackerSum
            
            for i in self.iReverse {
                
                if i != 14 && i != 29 && i != 44 && i != 59 {
                    
                    if self.deck[i] != nil {
                        
                        if self.deck[i+8] == nil {
                            
                            UIView.animate(withDuration: 0.18, animations: {
                                self.dotLabels[i]!.frame.origin.x += self.dotSize
                            })
                            
                            UIView.animate(withDuration: 0.18, animations: {
                                self.dotLabels[i]!.frame.origin.y += 2*self.dotSize
                            })
                            
                            self.dotLabels[i+8] = self.dotLabels[i]!
                            self.dotLabels[i] = nil
                            CATransaction.begin()
                            CATransaction.setAnimationDuration(0.18)
                            self.shapeLayers[i]!.frame.origin.x += self.dotSize
                            CATransaction.commit()
                            
                            CATransaction.begin()
                            CATransaction.setAnimationDuration(0.18)
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
                            CATransaction.commit()
                            
                            self.shapeLayers[i+8] = self.shapeLayers[i]!
                            self.shapeLayers[i] = nil
                            self.deck[i+8] = self.deck[i]
                            self.deck[i] = nil
                            self.trackerSum += 1
                            
                            
                            
                        }
                    }
                    
                }
            }
            
            
            
            self.bool = false
            }
        }
        isDropInProgress = false
        bool = true
        
    }
    
    
    @objc private func scoreFlashEnd() {
        UIView.animate(withDuration: 0.5, animations: {
            self.scoreFlash.alpha = 0.0
        })
        // scoreFlash.removeFromSuperview()
        score.text = currentScoreString
        if questButtons.count > 0 {
         
            var counter = 0
            outerloop: for i in questButtons {
     
                if questString == i.title(for: .normal) {
                   
                    self.questButtons[counter].removeFromSuperview()
                    questButtons.remove(at: counter)
                 
                    break outerloop
                }
                counter += 1
            }
        }
        if tagLevelIdentifier < 100 {
            if questButtons.count == 0 && !iWantToFinish {
                gameWinSequence()
            }
        }
        
        
        
    }
    
    private func noMoreMoves() {
        if tagLevelIdentifier < 100 {
            view.addSubview(backBlack)
            
            sequences.text = "No More Moves"
            sequences.layer.zPosition = 5
            view.addSubview(sequences)
            menuX.removeFromSuperview()
            menuX2.layer.zPosition = 5
            view.addSubview(menuX2)
            restart.layer.zPosition = 5
            
            view.addSubview(restart)
            
            
        } else {
            myGameCenter.addDataToGameCenter(score: currentScoreInt)
            myLoadSaveCoreData.saveScore(score: currentScoreInt)
            myLoadSaveCoreData.saveDemo(mode: "Solo")
            sequences.frame = CGRect(x: 0, y: (400/1334)*screenHeight, width: screenWidth, height: (110/750)*screenWidth)
            view.addSubview(backBlack)
            menuX2.layer.zPosition = 5
            view.addSubview(menuX2)
            restart.frame.origin.y = (1200/1334)*screenHeight
            restart.layer.zPosition = 5
            view.addSubview(restart)
            sequences.layer.zPosition = 5
            sequences.text = "Score: " + currentScoreString + "!"
            view.addSubview(sequences)
            self.view.addSubview(gameCenter)
            if tagLevelIdentifier == 100 {
            let imagePrompt = UIImage(named: "gamecenter.png")
            let imageViewPrompt = UIImageView(image: imagePrompt)
            imageViewPrompt.frame = CGRect(x: 0, y: (194/1334)*screenHeight, width: screenWidth, height: (126/750)*screenWidth)
            view.addSubview(imageViewPrompt)
            }
            view.addSubview(imageView)
                
            imageViewGlobal = imageView
            
            
            
            
        }
        
        
    }
    
    private func gameWinSequence() {
        menuX.removeFromSuperview()
        view.addSubview(backBlack)
        view.bringSubview(toFront: backBlack)
        view.addSubview(menuBox)
        //view.addSubview(continueToPlay)
        finishMessage.text = myNarrative.finishMessages[tagLevelIdentifier-1]
        view.addSubview(finishMessage)
        myLoadSaveCoreData.saveLevel(tagLevelIdentifier: tagLevelIdentifier)
        if tagLevelIdentifier == 1 {
            myLoadSaveCoreData.saveDemo(mode: "Campaign")
        }
        let array = [1,4,9,17,25,33,37,40,41,42,43]
        if array.contains(tagLevelIdentifier) {
            let image = UIImage(named: "Icon.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0.28*screenWidth, y: (300/1334)*screenHeight, width: 0.93*screenWidth/2, height: 0.6205*screenWidth)
            view.addSubview(imageView)
            imageViewGlobal = imageView
            finishMessage.frame.origin.y += (200/1334)*screenHeight
            
        } else {
            finishMessage.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*35)
            finishMessage.frame.origin.y -= screenHeight/4
        }
        
    }
    
    func addButtons() {
        
        //game center
        
        
        gameCenter.frame = CGRect(x: (343/750)*screenWidth, y: (320/1332)*screenHeight, width: 64*screenWidth/750, height: 64*screenWidth/750)
        gameCenter.setImage(UIImage(named: "gc.png"), for: .normal)
        gameCenter.addTarget(self, action: #selector(GameViewController.showGameCenterVC(_:)), for: .touchUpInside)
        
        
        // black background
        
        backBlack.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 0.9)
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        //scoreFlash label
        
        scoreFlash.text = additionalScoreString
        scoreFlash.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        scoreFlash.textAlignment = NSTextAlignment.center
        if tagLevelIdentifier > 99 {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*70)
        } else {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*50)
        }
        scoreFlash.frame = CGRect(x: 0, y: (88/1334)*screenHeight, width: screenWidth, height: (110/750)*screenWidth)
        
        //back button
        
        back.frame = CGRect(x: (59/750)*screenWidth, y: (594/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        back.setTitle("Resume Game", for: UIControlState.normal)
        back.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        back.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        back.backgroundColor = .clear
        back.layer.cornerRadius = 5
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        back.addTarget(self, action: #selector(GameViewController.back(_:)), for: .touchUpInside)
        //leaderboard button
        
        leaderboard.frame = CGRect(x: (59/750)*screenWidth, y: (726/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        leaderboard.setTitle("Game Center", for: UIControlState.normal)
        leaderboard.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        leaderboard.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        leaderboard.backgroundColor = .clear
        leaderboard.layer.cornerRadius = 5
        leaderboard.layer.borderWidth = 1
        leaderboard.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        leaderboard.addTarget(self, action: #selector(GameViewController.showGameCenterVC(_:)), for: .touchUpInside)
        
        //restart button
        
        restart.frame = CGRect(x: (59/750)*screenWidth, y: (324/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        restart.setTitle("Restart", for: UIControlState.normal)
        restart.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        restart.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        restart.backgroundColor = .clear
        restart.layer.cornerRadius = 5
        restart.layer.borderWidth = 1
        restart.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        restart.addTarget(self, action: #selector(GameViewController.restart(_:)), for: .touchUpInside)
        
        //sequencebutton
        
        sequence.frame = CGRect(x: (59/750)*screenWidth, y: (460/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        sequence.setTitle("Sequences", for: UIControlState.normal)
        sequence.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        sequence.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        sequence.backgroundColor = .clear
        sequence.layer.cornerRadius = 5
        sequence.layer.borderWidth = 1
        sequence.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        sequence.addTarget(self, action: #selector(GameViewController.sequence(_:)), for: .touchUpInside)
        
        //sequence label
        
        sequences.text = "Sequences"
        sequences.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        sequences.textAlignment = NSTextAlignment.center
        sequences.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*50)
        sequences.frame = CGRect(x: 0, y: (100/1334)*screenHeight, width: screenWidth, height: (110/750)*screenWidth)
        
        // show list button
        
        showList.frame = CGRect(x: (50/750)*screenWidth, y: (1044/1334)*screenHeight, width: 650*screenWidth/750, height: 87*screenWidth/750)
        showList.setTitle("List On", for: UIControlState.normal)
        showList.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        showList.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        showList.backgroundColor = .clear
        showList.layer.cornerRadius = 5
        showList.layer.borderWidth = 1
        showList.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        showList.addTarget(self, action: #selector(GameViewController.showList(_:)), for: .touchUpInside)
        
        
        
        yellowScore.text = currentScoreString
        yellowScore.textColor = UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0)
        yellowScore.textAlignment = NSTextAlignment.left
        yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*36)
        yellowScore.frame = CGRect(x: (50/750)*screenWidth, y: (1231/1334)*screenHeight, width: (250/750)*screenWidth, height: (46/750)*screenWidth)
        
        // red score label
        
        redScore.text = currentScoreString
        redScore.textColor = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0)
        redScore.textAlignment = NSTextAlignment.right
        redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*36)
        redScore.frame = CGRect(x: (450/750)*screenWidth, y: (1231/1334)*screenHeight, width: (250/750)*screenWidth, height: (46/750)*screenWidth)
        
        tutorialAnnotation2.text = "Pair; 3 Flush; 3 Straight; 3 of a Kind; 3 Straight Flush; 5 Straight; 5 Flush; 5 Full House; 4 of a Kind; 5 of a Kind; 5 Straight Flush\nTAP TO REMOVE"
        tutorialAnnotation2.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        tutorialAnnotation2.textAlignment = NSTextAlignment.center
        tutorialAnnotation2.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*12)
        tutorialAnnotation2.frame = CGRect(x: (100/750)*screenWidth, y: (1077/1334)*screenHeight, width: (550/750)*screenWidth, height: (150/750)*screenWidth)
        tutorialAnnotation2.numberOfLines = 0
        tutorialAnnotation2.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(GameViewController.disappear(_:)))
        tutorialAnnotation2.addGestureRecognizer(tap)
        //tap.delegate = self
        
        //tutorialAnnotation label
        
        tutorialAnnotation.text = "Find the following sequences to score points and climb the Game Center ranks\n(draw finger over dots to select)."
        tutorialAnnotation.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        tutorialAnnotation.textAlignment = NSTextAlignment.center
        tutorialAnnotation.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*14)
        tutorialAnnotation.numberOfLines = 0
        tutorialAnnotation.frame = CGRect(x: (100/750)*screenWidth, y: (60/1334)*screenHeight, width: (550/750)*screenWidth, height: (130/750)*screenWidth)
        
        //tutorialAnnotation3 label
        
        tutorialAnnotation3.text = "Find the below sequences to advance\n(draw finger over dots to select)."
        tutorialAnnotation3.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        tutorialAnnotation3.textAlignment = NSTextAlignment.center
        tutorialAnnotation3.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*14)
        tutorialAnnotation3.numberOfLines = 0
        tutorialAnnotation3.frame = CGRect(x: (100/750)*screenWidth, y: (60/1334)*screenHeight, width: (550/750)*screenWidth, height: (130/750)*screenWidth)
        
        
        //Menux Button (transition in exiting game)
        
        menuX.frame = CGRect(x: (25/750)*screenWidth, y: (25/750)*screenWidth, width: 50*screenWidth/750, height: 50*screenWidth/750)
        menuX.setTitle("X", for: UIControlState.normal)
        menuX.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        menuX.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuX.addTarget(self, action: #selector(GameViewController.menuX(_:)), for: .touchUpInside)
        
        //Menux2 Button (transition in exiting game)
        
        menuX2.frame = CGRect(x: (25/750)*screenWidth, y: (25/750)*screenWidth, width: 50*screenWidth/750, height: 50*screenWidth/750)
        menuX2.setTitle("X", for: UIControlState.normal)
        menuX2.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        menuX2.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuX2.addTarget(self, action: #selector(GameViewController.menuX2(_:)), for: .touchUpInside)
        
        //Okay Button
        
        okay.frame = CGRect(x: (199/750)*screenWidth, y: (1250/1334)*screenHeight, width: 353*screenWidth/750, height: 55*screenWidth/750)
        if tagLevelIdentifier == 100 {
            okay.frame.origin.y -= 50
        }
        okay.setTitle("Okay", for: UIControlState.normal)
        okay.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        okay.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        okay.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        okay.layer.cornerRadius = 5
        okay.layer.borderWidth = 1
        okay.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        okay.addTarget(self, action: #selector(GameViewController.okay(_:)), for: .touchUpInside)
        
        
        
        // finish Messages
        if tagLevelIdentifier < 100 {
            finishMessage.text = myNarrative.finishMessages[tagLevelIdentifier-1]
        }
        finishMessage.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        finishMessage.textAlignment = NSTextAlignment.center
        finishMessage.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*18)
        finishMessage.frame = CGRect(x: (100/750)*screenWidth, y: (557/1334)*screenHeight, width:(550/750)*screenWidth, height: (200/750)*screenWidth)
        finishMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        finishMessage.numberOfLines = 0
        
        //sequence row two label
        
        sequenceRowTwo.text = "50\n100\n150\n500\n750\n1500\n2500\n3500\n5,000\n10,000\n20,000\n"
        
        sequenceRowTwo.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        sequenceRowTwo.textAlignment = NSTextAlignment.right
        sequenceRowTwo.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        
        sequenceRowTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
        sequenceRowTwo.numberOfLines = 0
        
        //sequence row one label
        
        sequenceRowOne.text = "Pair\n3 Flush\n3 Straight\n3 of a Kind\n3 Straight Flush\n5 Straight\n5 Flush\n5 Full House\n4 of a Kind\n5 of a Kind\n5 Straight Flush"
        
        sequenceRowOne.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        sequenceRowOne.textAlignment = NSTextAlignment.left
        sequenceRowOne.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        
        sequenceRowOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        sequenceRowOne.numberOfLines = 0
        sequenceRowOne.frame = CGRect(x: (80/750)*screenWidth, y: (237/1334)*screenHeight, width: (500/750)*screenWidth, height: (750/750)*screenWidth)
        sequenceRowTwo.frame = CGRect(x: (173/750)*screenWidth, y: (262/1334)*screenHeight, width: (500/750)*screenWidth, height: (750/750)*screenWidth)
        
        //Continue To Play Button
        
        continueToPlay.frame = CGRect(x: (59/750)*screenWidth, y: (1209/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        continueToPlay.setTitle("Continue To Play", for: UIControlState.normal)
        continueToPlay.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        continueToPlay.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        continueToPlay.backgroundColor = .clear
        continueToPlay.layer.cornerRadius = 5
        continueToPlay.layer.borderWidth = 1
        continueToPlay.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        continueToPlay.addTarget(self, action: #selector(GameViewController.continueToPlay(_:)), for: .touchUpInside)
        
        
        //MenuBox Button
        
        menuBox.frame = CGRect(x: (59/750)*screenWidth, y: (1084/1334)*screenHeight, width: 633*screenWidth/750, height: 85*screenWidth/750)
        menuBox.setTitle("Menu", for: UIControlState.normal)
        menuBox.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        menuBox.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuBox.backgroundColor = .clear
        menuBox.layer.cornerRadius = 5
        menuBox.layer.borderWidth = 1
        menuBox.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        menuBox.addTarget(self, action: #selector(GameViewController.menuBox(_:)), for: .touchUpInside)
        
        
        //score label
        
        score.text = "SCORE"
        score.textColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        score.textAlignment = NSTextAlignment.right
        score.font = UIFont(name: "HelveticaNeue-CondensedBold", size: fontSizeMultiplier*36)
        //score.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        score.frame = CGRect(x: (200/750)*screenWidth, y: (1252/1334)*screenHeight, width: (525/750)*screenWidth, height: (60/750)*screenWidth)
        // view.addSubview(score)
        
        //Hint Button
        
        hint.frame = CGRect(x: (33/750)*screenWidth, y: (1252/1334)*screenHeight, width: 150*screenWidth/750, height: 60*screenWidth/750)
        hint.setTitle(String(tagLevelIdentifier), for: UIControlState.normal) //hack relace taglevel with "Hint"
        hint.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*36)
        hint.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        hint.addTarget(self, action: #selector(GameViewController.hint(_:)), for: .touchUpInside)
        //self.view.addSubview(hint)
        
        //Exit Button
        exit.frame = CGRect(x: (50/750)*screenWidth, y: (1145/1334)*screenHeight, width: 650*screenWidth/750, height: 87*screenWidth/750)
        exit.setTitle("Exit", for: UIControlState.normal)
        exit.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        exit.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        exit.addTarget(self, action: #selector(GameViewController.exit(_:)), for: .touchUpInside)
        exit.backgroundColor = .clear
        exit.layer.cornerRadius = 5
        exit.layer.borderWidth = 1
        exit.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        
        for i in 0...66 {
            
            var xValue = CGFloat()
            var yValue = CGFloat()
            switch i {
            case 0...6:
                yValue = topMargin + 0.5*dotSize
                
            case 7...14:
                yValue = topMargin + 2.5*dotSize
                
            case 15...21:
                yValue = topMargin + 4.5*dotSize
                
            case 22...29:
                yValue = topMargin + 6.5*dotSize
                
            case 30...36:
                yValue = topMargin + 8.5*dotSize
                
            case 37...44:
                yValue = topMargin + 10.5*dotSize
                
            case 45...51:
                yValue = topMargin + 12.5*dotSize
                
            case 52...59:
                yValue = topMargin + 14.5*dotSize
                
            case 60...66:
                yValue = topMargin + 16.5*dotSize
                
            default:
                break
            }
            
            switch i {
            case 0,15,30,45,60:
                xValue = 2*dotSize
                
            case 1,16,31,46,61:
                xValue = 4*dotSize
                
            case 2,17,32,47,62:
                xValue = 6*dotSize
                
            case 3,18,33,48,63:
                xValue = 8*dotSize
                
            case 4,19,34,49,64:
                xValue = 10*dotSize
                
            case 5,20,35,50,65:
                xValue = 12*dotSize
                
            case 6,21,36,51,66:
                xValue = 14*dotSize
                
            case 7,22,37,52:
                xValue = dotSize
                
            case 8,23,38,53:
                xValue = 3*dotSize
                
            case 9,24,39,54:
                xValue = 5*dotSize
                
            case 10,25,40,55:
                xValue = 7*dotSize
                
            case 11,26,41,56:
                xValue = 9*dotSize
                
            case 12,27,42,57:
                xValue = 11*dotSize
                
            case 13,28,43,58:
                xValue = 13*dotSize
                
            case 14,29,44,59:
                xValue = 15*dotSize
                
                
            default:
                break
            }
            
            let dotLabel = UILabel()
            dotLabels.append(dotLabel)
            dotLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            dotLabel.textAlignment = NSTextAlignment.center
            dotLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*17)
            dotLabel.frame = CGRect(x: xValue - dotSize/2, y: yValue - dotSize/1.9, width: dotSize, height: dotSize)
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: xValue,y: yValue), radius: (25/750)*screenWidth, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: xValue,y: yValue), radius: dotSize, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            let shapeLayer2 = CAShapeLayer()
            shapeLayer.fillColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0).cgColor
            shapeLayers.append(shapeLayer)
            shapeLayers2.append(shapeLayer2)
            shapeLayer.path = circlePath.cgPath
            shapeLayer2.path = circlePath2.cgPath
            
            
        }
        
        for i in 0...4 {
            let dotLabel = UILabel()
            displayLabels.append(dotLabel)
            dotLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            dotLabel.textAlignment = NSTextAlignment.center
            dotLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
            let _x = CGFloat(i)*(90/750)*screenWidth
            dotLabel.frame = CGRect(x: (160/750)*screenWidth + _x, y: (105/1334)*screenHeight, width: (70/750)*screenWidth, height: (70/750)*screenWidth)
            self.view.addSubview(dotLabel)
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: (195/750)*screenWidth + _x, y: (141/1334)*screenHeight), radius: (36/750)*screenWidth, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0).cgColor
            shapeLayer.path = circlePath.cgPath
            displayLayers.append(shapeLayer)
            shapeLayer.lineWidth = 4.0*screenWidth/750
            
            //
            //            view.layer.addSublayer(shapeLayer)
            //            self.view.addSubview(dotLabel)
        }
        
        // quest buttons
        
        if tagLevelIdentifier < 100 {
            var counterForSwitch: Int = 0
            for i in myShuffleAndDeal.quests[tagLevelIdentifier-1] {
                print(myShuffleAndDeal.quests[tagLevelIdentifier-1])
                let questButton = UIButton()
                questButtons.append(questButton)
                let multiplierx: CGFloat = CGFloat(counterForSwitch%3)*(150/705)*screenWidth
                var multipliery = CGFloat()
                switch counterForSwitch {
                case 0,1,2: multipliery = 0
                case 3,4,5: multipliery = 49
                case 6,7,8: multipliery = 98
                default: break
                }
                print("multipliery,multiplierx: \(multipliery), \(multiplierx)")
                counterForSwitch += 1
                questButton.setTitle(i, for: UIControlState.normal)
                questButton.frame = CGRect(x: (145/750)*screenWidth + multiplierx, y: ((1135 + multipliery)/1334)*screenHeight, width:(137/750)*screenWidth, height: (36/750)*screenWidth)
                questButton.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
                //questButton.textAlignment = NSTextAlignment.center
                questButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*12)
                questButton.backgroundColor = .clear
                questButton.layer.cornerRadius = 3
                questButton.layer.borderWidth = 1
                questButton.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
                questButton.addTarget(self, action: #selector(GameViewController.describeQuest(_:)), for: .touchUpInside)
                view.addSubview(questButton)
            }
        }
        
    }
    
    @objc private func exit(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.sequences.removeFromSuperview()
        self.showList.removeFromSuperview()
        self.sequenceRowTwo.removeFromSuperview()
        self.sequenceRowOne.removeFromSuperview()
        self.menuX2.removeFromSuperview()
        self.exit.removeFromSuperview()
    }
    @objc private func menuX(_ button: UIButton) {
        
        view.addSubview(backBlack)
        view.bringSubview(toFront: backBlack)
        view.addSubview(restart)
        if tagLevelIdentifier < 99 { back.frame.origin.y = (460/1334)*screenHeight
            
        } else {
            view.addSubview(sequence)
            view.addSubview(leaderboard)
        }
        view.addSubview(back)
        view.addSubview(menuX2)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        if seg == "Menu" {
        //
        //            let gameView: MenuViewController = segue.destination as! MenuViewController
        //
        //            gameView.tagLevelIdentifier = tagLevelIdentifier
        //
        //        } else {
        //
        //        }
    }
    @objc private func menuX2(_ button: UIButton) {
        if tagLevelIdentifier > 99 {
            self.performSegue(withIdentifier: "fromGameToIntro", sender: self)
        } else {
            seg = "Menu"
            self.performSegue(withIdentifier: "fromGameToMenu", sender: self)
        }
    }
    
    @objc private func menuBox(_ button: UIButton) {
        seg = "Menu"
        self.performSegue(withIdentifier: "fromGameToMenu", sender: self)
    }
    @objc private func okay(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.tutorialAnnotation3.removeFromSuperview()
        self.sequenceRowOne.removeFromSuperview()
        self.sequenceRowTwo.removeFromSuperview()
        self.okay.removeFromSuperview()
        
        if tagLevelIdentifier == 100 {
            view.addSubview(tutorialAnnotation2)
            view.addSubview(score)
            view.addSubview(menuX)
            self.tutorialAnnotation.removeFromSuperview()
        }
        
    }
    @objc private func continueToPlay(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.menuBox.removeFromSuperview()
        self.continueToPlay.removeFromSuperview()
        self.finishMessage.removeFromSuperview()
        iWantToFinish = true
        if imageViewGlobal.isDescendant(of: view) {
            imageViewGlobal.removeFromSuperview()
        }
    }
    @objc private func hint(_ button: UIButton) {
        
    }
    
    @objc private func describeQuest(_ button: UIButton) {
        switch button.title(for: .normal)! {
        case "Pair": addDescriptionNamed(named: "pair.png")
        case "3 Kind": addDescriptionNamed(named: "3Kind.png")
        case "3 Straight": addDescriptionNamed(named: "3Straight.png")
        case "3 Flush": addDescriptionNamed(named: "3Flush.png")
        case "3 Str. Flush": addDescriptionNamed(named: "3StraightFlush.png")
        case "4 Kind": addDescriptionNamed(named: "4Kind.png")
        case "5 Kind": addDescriptionNamed(named: "5Kind.png")
        case "5 Straight": addDescriptionNamed(named: "5Straight.png")
        case "5 Flush": addDescriptionNamed(named: "5Flush.png")
        case "5 Full House": addDescriptionNamed(named: "5FullHouse")
        case "5 Str. Flush": addDescriptionNamed(named: "5StraightFlush.png")
        default: break
        }
        _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(GameViewController.disappear3), userInfo: nil, repeats: false)
    }
    @objc private func disappear3(_ button: UIButton) {
        imageView.removeFromSuperview()
    }
    
    @objc private func showList(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.sequences.removeFromSuperview()
        self.showList.removeFromSuperview()
        self.sequenceRowTwo.removeFromSuperview()
        self.sequenceRowOne.removeFromSuperview()
        self.exit.removeFromSuperview()
        self.menuX2.removeFromSuperview()
        view.addSubview(tutorialAnnotation2)
    }
    @objc private func disappear(_ button: UIButton) {
        tutorialAnnotation2.text = "CLICK X TO SEE SEQUENCES ANY TIME"
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameViewController.disappear2), userInfo: nil, repeats: false)
    }
    @objc private func disappear2(_ button: UIButton) {
        self.tutorialAnnotation2.removeFromSuperview()
        tutorialAnnotation2.text = "Pair; 3 Flush; 3 Straight; 3 of a Kind; 3 Straight Flush; 5 Straight; 5 Flush; 5 Full House; 4 of a Kind; 5 of a Kind; 5 Straight Flush\nTAP TO REMOVE"
    }
    
    
    @objc private func back(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.restart.removeFromSuperview()
        self.sequence.removeFromSuperview()
        self.back.removeFromSuperview()
        self.menuX2.removeFromSuperview()
        self.leaderboard.removeFromSuperview()
        
    }
    @objc private func restart(_ button: UIButton) {
        questButtons.removeAll()
        shapeLayers.removeAll()
        shapeLayers2.removeAll()
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        myAllPossibilities.stopEverything = true
        
        view.addSubview(menuX)
        currentScoreInt = 0
        goalScoreInt = 20000
        highestHand = [1,1,1,1,1]
        _highestHand = [1,1,1,1,1]
        highestSoFar = 1
        
        
        shuffled.removeAll()
        allNumbers.removeAll()
        dotLabels.removeAll()
        addButtons()
        for i in 0..<84 {
            allNumbers.append(i)
        }
        for _ in 0..<67 {
            let randomNumber = Int(arc4random_uniform(UInt32(allNumbers.count)))
            if let index = allNumbers.index(of: allNumbers[randomNumber]) {
                shuffled.append(allNumbers[randomNumber])
                allNumbers.remove(at:index)
            }
        }
        deck = shuffled
        lastCardDisplayed = 999
        
        
        populateDots()
        view.addSubview(menuX)
    }
    private func displayTutorial() {
        
        view.addSubview(backBlack)
        view.addSubview(tutorialAnnotation)
        view.addSubview(sequenceRowOne)
        view.addSubview(sequenceRowTwo)
        view.addSubview(okay)
    }
    
    private func displayTutorialForCampaign() {
        
        //view.addSubview(backBlack)
        // ADD SEQUENCE BOXES
        view.addSubview(tutorialAnnotation3)
        // view.addSubview(okay)
    }
    
    @objc private func showGameCenterVC(_ sender: UIButton) {
        GCHelper.sharedInstance.showGameCenter(self, viewState: .leaderboards)
    }
    
    @objc private func sequence(_ button: UIButton) {
        self.restart.removeFromSuperview()
        self.sequence.removeFromSuperview()
        self.back.removeFromSuperview()
        
        view.addSubview(sequences)
        view.addSubview(showList)
        view.addSubview(sequenceRowOne)
        view.addSubview(sequenceRowTwo)
        view.addSubview(exit)
        self.leaderboard.removeFromSuperview()
    }
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    
    private func addDescriptionNamed(named: String) {
        let image = UIImage(named: named)
        imageView.image = image!
        imageView.frame.origin.x = (123/750)*screenWidth
        imageView.frame.origin.y = (359/1334)*screenHeight
        imageView.frame.size = CGSize( width: (504/750)*screenWidth, height: (220/750)*screenWidth)
        
        view.addSubview(imageView)
    }
    
}
