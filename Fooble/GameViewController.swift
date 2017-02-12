//
//  GameViewController.swift
//  Ransom!
//
//  Created by Aaron Halvorsen on 12/28/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//
import UIKit
import GCHelper

class GameViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let topMargin = (269/1332)*UIScreen.main.bounds.height
    var seg = "nothing"
    var center = Int()
    var centerPoint = CGPoint()
    var passedLevel = Bool()
    var panTouchLocation = CGPoint()
    var locationOfBeganPan = CGPoint()
    var locationOfEndPan = CGPoint()
    var tagLevelIdentifier = Int()
    var frontMargin = CGFloat()//(35/750)*screenWidth
    var goalScoreInt = Int() {didSet{goalScoreString = String(goalScoreInt)}}
    var goalScoreString = String()
    var currentScoreString = String()
    var currentScoreInt = Int() {didSet{currentScoreString = String(currentScoreInt)}}
    let dotSize = (1/16)*UIScreen.main.bounds.width
    var hintNumbersAsStrings = [String]()
    let dotNumbersAsStrings = [String]()
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
    var myColor = PersonalColor()
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
    var questButtons = [UIButton]()
    
    
    var shapeLayers = [CAShapeLayer?]()
    var dotLabels = [UILabel?]()
    var (displayLayers, shapeLayers2, hintDisplay) = ([CAShapeLayer](), [CAShapeLayer](), [CAShapeLayer]())
    var (annoations, hintNumberLabels, displayLabels) = ([UILabel](), [UILabel](), [UILabel]())
    let (score, scoreFlash, sequences, yellowScore, redScore, finishMessage, tutorialAnnotation, tutorialAnnotation2, tutorialAnnotation3, sequenceRowOne, sequenceRowTwo) = (UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel())
    let (okay, hint, exit, leaderboard, restart, sequence, back, exitSequences, showList, gameCenter, menuX, menuX2, menuBox, continueToPlay) = (UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton())
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = myColor.background
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
        UIView.animate(withDuration: 0.1) {self.view.alpha = 0.9}
        print("tagLevelIdentifier: \(tagLevelIdentifier)")
        if tagLevelIdentifier > 99 {
            GCHelper.sharedInstance.authenticateLocalUser()
        }
    }
    
    private func populateDots() {
        
        lastCardDisplayed = 999
        for i in 0..<67 {
            switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
            case .custom1:
                shapeLayers[i]!.strokeColor = myColor.pink.cgColor
                
            case .custom2:
                shapeLayers[i]!.strokeColor = myColor.yellow.cgColor
                
            case .custom3:
                shapeLayers[i]!.strokeColor = myColor.blue.cgColor
                
            case .custom4:
                shapeLayers[i]!.strokeColor = myColor.white.cgColor
                
            }
            let linewidth = 3.0*screenWidth/750
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
                        case .custom1:
                            displayLayers[0].strokeColor = myColor.pink.cgColor
                        case .custom2:
                            displayLayers[0].strokeColor = myColor.yellow.cgColor
                        case .custom3:
                            displayLayers[0].strokeColor = myColor.blue.cgColor
                        case .custom4:
                            displayLayers[0].strokeColor = myColor.white.cgColor
                            
                        }
                        
                        displayLabels[0].text = String(deck[i]!%7 + 1)
                        lastIndex = i
                      //  print("firstindex: \(lastIndex)")
                        
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
        outerloop: if gesture.state == UIGestureRecognizerState.changed && futureIndexes.count > 0 {
            if futureIndexes[0] != 666 {
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
                        
//                       print("future indexes: \(futureIndexes)")
                        for i in futureIndexes {
                            
                            var futureRow = mySelection.thisRow(index: i)
            
                            let lastRow = mySelection.thisRow(index: lastIndex)
                 
                            switch lastIndex {
                            case 6,14,21,29,36,44,51,59: //this sabatoges
                                if i == lastIndex + 1 {
                                    futureRow = lastRow + 2
                                }
                            case 7,15,22,30,37,45,52,60:
                                if i == lastIndex - 1 {
                                    futureRow = lastRow + 2
                                }
                            default: break
                            }
                    
                            if deck[i] != nil && dotLabels[i] != nil {
                                if shapeLayers2[i].path!.contains(locationOfPan) && dotLabels[i]!.isDescendant(of: self.view) && (lastCardDisplayed != deck[i]!) {

                                    
                                    if futureRow == lastRow - 1 || futureRow == lastRow + 1 || futureRow == lastRow {
                                        switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
                                        case .custom1:
                                            displayLayers[count].strokeColor = myColor.pink.cgColor
                                        case .custom2:
                                            displayLayers[count].strokeColor = myColor.yellow.cgColor
                                        case .custom3:
                                            displayLayers[count].strokeColor = myColor.blue.cgColor
                                        case .custom4:
                                            displayLayers[count].strokeColor = myColor.white.cgColor
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
                                                } else {
                                                    futureIndexes.removeAll()
                                                    futureIndexes.append(666)
                                                }
                                            } else {
                                                futureIndexes.removeAll()
                                                futureIndexes.append(666)
                                            }
                                        } else {
                                            futureIndexes.removeAll()
                                            futureIndexes.append(666)
                                        }
                                        
                                        view.layer.addSublayer(displayLayers[count])
                                        self.view.addSubview(displayLabels[count])
                                        hand.append(deck[i]!)
                                        handIndexes.append(i)
                                        count += 1
                                    }
                                    //
                                }
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
            
                let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)}
            print("checkall")
        self.delay(bySeconds: 0.6) {
            if !self.myAllPossibilities.stopEverything {
                self.noMoreMoves()
            }
        }
    }
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
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
        view.addSubview(finishMessage)
        myLoadSaveCoreData.saveLevel(tagLevelIdentifier: tagLevelIdentifier)
        if tagLevelIdentifier == 1 {
            myLoadSaveCoreData.saveDemo(mode: "Campaign")
        }
        let array = [1,4,9,17,25,33,37,40,41,42,43]
        if array.contains(tagLevelIdentifier) {
            let image = UIImage(named: "menuIcon.png")
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
    
    func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor, act:
        Selector, addSubview: Bool) {
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: width*screenWidth/750, height: height*screenWidth/750)
        name.setTitle(title, for: UIControlState.normal)
        name.titleLabel!.font = UIFont(name: font, size: fontSizeMultiplier*fontSize)
        name.setTitleColor(titleColor, for: .normal)
        name.backgroundColor = bgColor
        name.layer.cornerRadius = cornerRad
        name.layer.borderWidth = boarderW
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
    func addButtons() {
        
        //game center
        gameCenter.frame = CGRect(x: (343/750)*screenWidth, y: (320/1332)*screenHeight, width: 64*screenWidth/750, height: 64*screenWidth/750)
        gameCenter.setImage(UIImage(named: "gc.png"), for: .normal)
        gameCenter.addTarget(self, action: #selector(GameViewController.showGameCenterVC(_:)), for: .touchUpInside)
        
        // black background
        backBlack.backgroundColor = myColor.background
        backBlack.alpha = 0.9
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        //scoreFlash label
        addLabel(name: scoreFlash, text: additionalScoreString, textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 70, x: 0, y: 88, width: 750, height: 110, lines: 0)
        if tagLevelIdentifier > 99 {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*70)
        } else {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*50)
        }
        
        //back button
        addButton(name: back, x: 59, y: 594, width: 633, height: 85, title: "Resume Game", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.back(_:)), addSubview: false)
        //leaderboard button
        addButton(name: leaderboard, x: 59, y: 726, width: 633, height: 85, title: "Game Center", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.white, act: #selector(GameViewController.showGameCenterVC(_:)), addSubview: false)
        //restart button
        addButton(name: restart, x: 59, y: 324, width: 633, height: 85, title: "Restart", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.white, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.restart(_:)), addSubview: false)
        //sequencebutton
        addButton(name: sequence, x: 59, y: 460, width: 633, height: 85, title: "Sequences", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.sequence(_:)), addSubview: false)
        //sequence label
        addLabel(name: sequences, text: "Sequences", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 50, x: 0, y: 100, width: 750, height: 110, lines: 0)
        // show list button
        addButton(name: showList, x: 50, y: 1044, width: 650, height: 87, title: "List On", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.showList(_:)), addSubview: false)
        addLabel(name: yellowScore, text: currentScoreString, textColor: UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0), textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 36, x: 50, y: 1231, width: 250, height: 46, lines: 0)
        // red score label
        addLabel(name: redScore, text: currentScoreString, textColor: myColor.red, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 36, x: 450, y: 1231, width: 250, height: 46, lines: 0)
        addLabel(name: tutorialAnnotation2, text: "Pair; 3 Flush; 3 Straight; 3 of a Kind; 3 Straight Flush; 5 Straight; 5 Flush; 5 Full House; 4 of a Kind; 5 of a Kind; 5 Straight Flush\nTAP TO REMOVE", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 12, x: 100, y: 1077, width: 550, height: 150, lines: 0)
        tutorialAnnotation2.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(GameViewController.disappear(_:)))
        tutorialAnnotation2.addGestureRecognizer(tap)
        //tutorialAnnotation label
        addLabel(name: tutorialAnnotation, text: "Find the following sequences to score points and climb the Game Center ranks\n(draw finger over dots to select).", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 14, x: 100, y: 60, width: 550, height: 130, lines: 0)
        //tutorialAnnotation3 label
        addLabel(name: tutorialAnnotation3, text: "Find the below sequences to advance\n(draw finger over dots to select).", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 14, x: 100, y: 60, width: 550, height: 130, lines: 0)
        //Menux Button (transition in exiting game)
        addButton(name: menuX, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GameViewController.menuX(_:)), addSubview: false)
        //Menux2 Button (transition in exiting game)
        addButton(name: menuX2, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GameViewController.menuX2(_:)), addSubview: false)
        //Okay Button
        addButton(name: okay, x: 199, y: 1250, width: 353, height: 55, title: "Okay", font: "HelveticaNeue-Bold", fontSize: 20, titleColor: myColor.offWhite, bgColor: myColor.background, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.okay(_:)), addSubview: false)
        if tagLevelIdentifier == 100 {
            okay.frame.origin.y -= 50
        }
        // finish Messages
        if tagLevelIdentifier < 100 {
            addLabel(name: finishMessage, text: myNarrative.finishMessages[tagLevelIdentifier-1], textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 18, x: 100, y: 557, width: 550, height: 200, lines: 0)}
        
        finishMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        finishMessage.numberOfLines = 0
        //sequence row two label
        addLabel(name: sequenceRowTwo, text: "50\n100\n150\n500\n750\n1500\n2500\n3500\n5,000\n10,000\n20,000\n", textColor: myColor.offWhite, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 20, x: 173, y: 262, width: 500, height: 750, lines: 0)
        //sequence row one label
        addLabel(name: sequenceRowOne, text: "Pair\n3 Flush\n3 Straight\n3 of a Kind\n3 Straight Flush\n5 Straight\n5 Flush\n5 Full House\n4 of a Kind\n5 of a Kind\n5 Straight Flush", textColor: myColor.offWhite, textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 20, x: 80, y: 237, width: 500, height: 750, lines: 0)
        //Continue To Play Button
        addButton(name: continueToPlay, x: 59, y: 1209, width: 633, height: 85, title: "Continue To Play", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.continueToPlay(_:)), addSubview: false)
        //MenuBox Button
        addButton(name: menuBox, x: 59, y: 1084, width: 633, height: 85, title: "Menu", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.menuBox(_:)), addSubview: false)
        //score label
        addLabel(name: score, text: "SCORE", textColor: myColor.offWhite, textAlignment: .right, fontName: "HelveticaNeue-CondensedBold", fontSize: 36, x: 200, y: 1252, width: 525, height: 60, lines: 0)
        print("taglevel")
        print(tagLevelIdentifier)
        if tagLevelIdentifier == 101 { view.addSubview(score) }
        //Exit Button
        addButton(name: exit, x: 50, y: 1145, width: 650, height: 87, title: "Exit", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.exit(_:)), addSubview: false)
        
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
            
            addLabel(name: dotLabel, text: "", textColor: myColor.white, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 14, x: 750*(xValue - dotSize/2)/screenWidth, y: 1334*(yValue - dotSize/1.9)/screenHeight, width: 750*dotSize/screenWidth, height: 750*dotSize/screenWidth, lines: 0)
            
            dotLabels.append(dotLabel)
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: xValue,y: yValue), radius: (25/750)*screenWidth, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: xValue,y: yValue), radius: dotSize, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            let shapeLayer2 = CAShapeLayer()
            shapeLayer.fillColor = myColor.background.cgColor
            shapeLayers.append(shapeLayer)
            shapeLayers2.append(shapeLayer2)
            shapeLayer.path = circlePath.cgPath
            shapeLayer2.path = circlePath2.cgPath
        }
        
        for i in 0...4 {
            let displayLabel = UILabel()
            addLabel(name: displayLabel, text: "", textColor: myColor.white, textAlignment: .center, fontName: "HelverticaNeue-Bold", fontSize: 25, x: 160 + 90*CGFloat(i), y: 105, width: 70, height: 70, lines: 0)
            displayLabels.append(displayLabel)
            
            let _x = CGFloat(i)*(90/750)*screenWidth
            
            self.view.addSubview(displayLabel)
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: (195/750)*screenWidth + _x, y: (141/1334)*screenHeight), radius: (36/750)*screenWidth, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = myColor.background.cgColor
            shapeLayer.path = circlePath.cgPath
            displayLayers.append(shapeLayer)
            shapeLayer.lineWidth = 4.0*screenWidth/750
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
                addButton(name: questButton, x: 145 + 750*multiplierx/screenWidth, y: 1135 + multipliery, width: 137, height: 36, title: i, font: "HelveticaNeue-Bold", fontSize: 11, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 3, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.describeQuest(_:)), addSubview: true)
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
    
    private func addDescriptionNamed(named: String) {
        let image = UIImage(named: named)
        imageView.image = image!
        imageView.frame.origin.x = (123/750)*screenWidth
        imageView.frame.origin.y = (1100/1334)*screenHeight
        imageView.frame.size = CGSize( width: (504/750)*screenWidth, height: (220/750)*screenWidth)
        
        view.addSubview(imageView)
    }
    
}
