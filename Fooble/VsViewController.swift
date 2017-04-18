//
//  VsViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/3/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import AudioToolbox

class VsViewController: GameSetupViewController {
    
    var a = [Int]()
    var p = Int()
    var futureIndexes = [Int]()
    var priorIndex = Int()
    var lastIndex = Int()
    var thisTurn: Team = .red
    var oneTurnAgo: Team = .start
    var twoTurnsAgo: Team = .start
    var extraDots = [Int]() {didSet{
        if extraDots.count < 7 && test { sequences.text = "Game Over (5 deck max)"; sequences.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20); view.addSubview(sequences)
            self.view.removeGestureRecognizer(self.swipeRight as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeLeft as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeDown as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.pan as UIGestureRecognizer) }}}
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var dynamicBarCue = Timer()
    var ticker: Float = 0.0 //{didSet { print(ticker)}}
    var percentageOfBar: CGFloat = 1.0
    var test = false
    var timerRanOutOn: Team = .red
    var yellowPointsInt = Int() {didSet{yellowPointsString = String(yellowPointsInt)}}
    var yellowPointsString = "Score"
    var redPointsInt = Int() {didSet{redPointsString = String(redPointsInt)}}
    var redPointsString = "Score"
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // IF TAGLEVELIDENTIFIER = 1000 .yellow team is AI
        self.view.backgroundColor = myColor.background
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.respondToPanGesture(_:)))
        self.view.addGestureRecognizer(pan)
        currentScoreInt = 0
        goalScoreInt = 20000
        for i in 0..<60 {
            
            iReverse.append(59-i)
            
        }
        addLabels()
        addButtons()
        view.addSubview(redScore)
        view.addSubview(yellowScore)
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
    override func viewWillAppear(_ animated: Bool) {
        populateDotsExtended()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {self.view.alpha = 0.9}
        
        
        startTimer()
        
        for _ in 0..<allNumbers.count {
            let randomNumber = Int(arc4random_uniform(UInt32(allNumbers.count)))
            if let index = allNumbers.index(of: allNumbers[randomNumber]) {
                extraDots.append(allNumbers[randomNumber])
                allNumbers.remove(at:index)
            }
        }
        for i in 0..<84 {
            allNumbers.append(i)
        }
        for _ in 0..<84 {
            let randomNumber = Int(arc4random_uniform(UInt32(allNumbers.count)))
            if let index = allNumbers.index(of: allNumbers[randomNumber]) {
                extraDots.append(allNumbers[randomNumber])
                allNumbers.remove(at:index)
            }
        }
        test = true
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(VsViewController.respondToSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(VsViewController.respondToSwipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(VsViewController.respondToSwipeDown))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
    }
    
    private func populateDotsExtended() {
        view.addSubview(menuX)
    }
    
    
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
        if thisTurn == .yellow && tagLevelIdentifier == 1000 {
            //do nothing
        } else {
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
                        if shapeLayers2[firstIndexDisplayed].path!.contains(locationOfPan){//hovering over first selected dot erases display dots and starts selection over
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
                    
                    if count < 5  && count > 0 { //new
                        if self.displayLabels[0].isDescendant(of: self.view) {
                            
                            
                            for i in futureIndexes {  // this is a check to make sure you're not selecting something that is the next index but on the other side of screen
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
                                        potentialFutureIndex = mySelection.linearCheckForNumberAfterLast(last: i, prior: priorIndex)  // figure out what dot is linearly next on the board
                                        
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if gesture.state == UIGestureRecognizerState.ended {
                
                
                hand = myCalculator.reorderHand(hand: hand)  // reorder hand so can figure out score
                
                additionalScoreInt = myCalculator.pointAmount(hand: hand)  //determine score if any
                
                if additionalScoreInt != 0 {  // if it's a valid sequence the score will be >0
                    
                    for i in handIndexes {
                        dotLabels[i]!.removeFromSuperview()
                        deck[i] = nil
                        shapeLayers[i]!.removeFromSuperlayer()
                    }
                    for i in 0...4 {
                        if displayLabels[i].isDescendant(of: self.view) {
                            displayLabels[i].removeFromSuperview()
                            displayLayers[i].removeFromSuperlayer()
                        }
                    }
                    
                    
                    scoreFlash.text = additionalScoreString
                    scoreFlash.alpha = 0
                    self.view.addSubview(scoreFlash)
                    UIView.animate(withDuration: 0.5, animations: {
                        self.scoreFlash.alpha = 1.0
                    })
                    _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(VsViewController.scoreFlashEnd), userInfo: nil, repeats: false)
                    if thisTurn == .red {
                        redPointsInt += additionalScoreInt
                    } else {
                        yellowPointsInt += additionalScoreInt
                    }
                    view.removeGestureRecognizer(pan as UIGestureRecognizer)
                    
                    
                }
            }
        }
    }
    var timerBool = true
    private func swipeChoices() {
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeDown)
        
        let image = UIImage(named: "Swipe.png")
        imageView.image = image!
        imageView.frame = CGRect(x: (308/750)*screenWidth, y: (104/1334)*screenHeight, width: (133/750)*screenWidth, height: (90/750)*screenWidth)
        view.addSubview(imageView)
        if tagLevelIdentifier == 1000 && thisTurn == .yellow {
            self.view.removeGestureRecognizer(self.swipeRight as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeLeft as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeDown as UIGestureRecognizer)
        }
        
        
        
        
    }
    
    private func noMoreMoves() {
        if tagLevelIdentifier == 1000 {
            dynamicBarCue.invalidate()
        }
        myLoadSaveCoreData.saveDemo(mode: "Multiplayer")
        backBlack.alpha = 1.0
        view.addSubview(backBlack)
        for dot in dotLabels {
            dot?.removeFromSuperview()
        }
        menuX.removeFromSuperview()
        menuX2.layer.zPosition = 5
        view.addSubview(menuX2)
        if yellowPointsInt > redPointsInt {
            if tagLevelIdentifier == 1000 {
                sequences.text = "iPhone Wins"
            } else {
                sequences.text = "Yellow Wins!"}
        } else if redPointsInt > yellowPointsInt {
            if tagLevelIdentifier == 1000 {
                sequences.text = "You Win!"
            } else {
                sequences.text = "Red Wins!"
            }
        } else {
            sequences.text = "Flip a coin?"
        }
        yellowScore.frame = CGRect(x: (0/750)*screenWidth, y: (460/1334)*screenHeight, width: screenWidth, height: (140/750)*screenWidth)
        redScore.frame = CGRect(x: (0/750)*screenWidth, y: (600/1334)*screenHeight, width: screenWidth, height: (140/750)*screenWidth)
        yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*80)
        redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*80)
        yellowScore.textAlignment = NSTextAlignment.center
        redScore.textAlignment = NSTextAlignment.center
        
        redScore.layer.zPosition = 5
        yellowScore.layer.zPosition = 5
        sequences.layer.zPosition = 5
        view.addSubview(sequences)
        
    }
    
    @objc private func respondToSwipeLeft() {
        for i in handIndexes {shapeLayers[i] = nil}  /// this is new
        print("swipeLeftfunc")
        imageView.removeFromSuperview()
        dropLeft(currentDeck: deck)
        
        delay(bySeconds: 0.5) {
            self.dropRight(currentDeck: self.deck)
            
            let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)
            
            self.delay(bySeconds: 0.5) {
                if !self.myAllPossibilities.stopEverything {
                    self.noMoreMoves()
                    print("nomoremoves3")
                    
                    self.bar.removeFromSuperview()
                }
            }
        }
        if self.tagLevelIdentifier == 1000 && thisTurn == .yellow {
            self.delay(bySeconds: 2.0) {self.takeAITurn() }
        } else {
            self.view.removeGestureRecognizer(self.swipeRight as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeLeft as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeDown as UIGestureRecognizer)
            self.view.addGestureRecognizer(self.pan)
        }
        
    }

    @objc private func respondToSwipeRight() {
        for i in handIndexes {shapeLayers[i] = nil}  /// this is new
        print("swipeRightfunc")
        imageView.removeFromSuperview()
        dropRight(currentDeck: deck)
        
        delay(bySeconds: 0.5) {
            self.dropLeft(currentDeck: self.deck)
            if self.dotLabels[45] == nil && self.dotLabels[45] == nil {
                let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)}
            if !self.myAllPossibilities.stopEverything {
                self.noMoreMoves()
                
                
                self.bar.removeFromSuperview()
            }
        }
        if self.tagLevelIdentifier == 1000 && thisTurn == .yellow {
            self.delay(bySeconds: 2.0)  {self.takeAITurn() }
        } else {
            self.view.removeGestureRecognizer(self.swipeRight as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeLeft as UIGestureRecognizer)
            self.view.removeGestureRecognizer(self.swipeDown as UIGestureRecognizer)
            self.view.addGestureRecognizer(self.pan)
            
        }
        
    }
    @objc private func respondToSwipeDown() {
        print("swipedownfunc")
        imageView.removeFromSuperview()
        
        a = handIndexes
        
        for i in 0..<a.count {
            
            deck[a[i]] = extraDots[0]
            dotLabels[a[i]]!.text = String(deck[a[i]]!%7 + 1)
            dotLabels[a[i]]!.alpha = 0.0
            
            extraDots.remove(at:0)
            switch myShuffleAndDeal.whatColorIsCard(card: deck[a[i]]!) {
            case .custom1:
                dotLabels[a[i]]?.layer.borderColor = myColor.pink.cgColor
           //     shapeLayers[a[i]]!.strokeColor = myColor.pink.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom2:
                dotLabels[a[i]]?.layer.borderColor = myColor.yellow.cgColor
            //    shapeLayers[a[i]]!.strokeColor =  myColor.yellow.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom3:
                dotLabels[a[i]]?.layer.borderColor = myColor.blue.cgColor
             //   shapeLayers[a[i]]!.strokeColor =  myColor.blue.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom4:
                dotLabels[a[i]]?.layer.borderColor = myColor.white.cgColor
           //     shapeLayers[a[i]]!.strokeColor = myColor.white.cgColor
           //     delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            }
            view.addSubview(dotLabels[a[i]]!)
            if dotLabels[45] == nil && dotLabels[45] == nil {
                let _ = myAllPossibilities.calculateBestHandIndexes(deck: deck)}
            
            if !myAllPossibilities.stopEverything {
                print("nomoremoves1")
                noMoreMoves()
                
                bar.removeFromSuperview()
            }
            
            
            UIView.animate(withDuration: 1.0, animations: {
                self.dotLabels[self.a[i]]!.alpha = 1.0
                
            })
        }
        
        if tagLevelIdentifier == 1000 && thisTurn == .yellow {
            delay(bySeconds: 2.0) {self.takeAITurn()}
        } else {
            
            view.removeGestureRecognizer(swipeRight as UIGestureRecognizer)
            view.removeGestureRecognizer(swipeLeft as UIGestureRecognizer)
            view.removeGestureRecognizer(swipeDown as UIGestureRecognizer)
            self.view.addGestureRecognizer(pan)
        }
    }
    
        
        
    enum Team {
        case red
        case yellow
        case start
    }
    
    private func aISwipe() {
        print("aiswipefunc")
        delay(bySeconds: 0.1) {
            let swipeNumber = Int(arc4random_uniform(3))
            switch swipeNumber {
            case 0: self.respondToSwipeDown()
            case 1: self.respondToSwipeLeft()
            default: self.respondToSwipeRight()
            }
        }
    }
    
    private func aISequence() {
        print("aisequencefunc")
        
        
        view.removeGestureRecognizer(pan as UIGestureRecognizer)
        view.removeGestureRecognizer(swipeRight as UIGestureRecognizer)
        view.removeGestureRecognizer(swipeLeft as UIGestureRecognizer)
        view.removeGestureRecognizer(swipeDown as UIGestureRecognizer)
        
        delay(bySeconds: 1.5) {self.aISwipe()}
    }
    
    private func aITurnEnd() {
        print("aiturnendfunc")
        self.view.addGestureRecognizer(self.swipeRight)
        self.view.addGestureRecognizer(self.swipeLeft)
        self.view.addGestureRecognizer(self.swipeDown)
    }
    
    
    
    
    private func takeAITurn() {
        print("takeAITurnFunc")
        
        
        
        handIndexes = myAllPossibilities.calculateBestHandIndexes(deck: deck)
        a=handIndexes
        if myAllPossibilities.handScore != nil {
            p = myAllPossibilities.handScore!
        }
        if myAllPossibilities.stopEverything {
            if p != 0 {
                hand.removeAll()
                for i in a {
                    hand.append(deck[i]!)
                }
            } else {
                //no more moves
            }
            
            for i in 0..<a.count {
                switch myShuffleAndDeal.whatColorIsCard(card: deck[a[i]]!) {
                case .custom1:
                    displayLayers[i].strokeColor = myColor.pink.cgColor
                    
                case .custom2:
                    displayLayers[i].strokeColor = myColor.yellow.cgColor
                    
                case .custom3:
                    displayLayers[i].strokeColor = myColor.blue.cgColor
                    
                case .custom4:
                    displayLayers[i].strokeColor = myColor.white.cgColor
                    
                }
                displayLabels[i].text = String(deck[a[i]]!%7 + 1)
                view.layer.addSublayer(displayLayers[i])
                self.view.addSubview(displayLabels[i])
                
            }
            additionalScoreInt = p
            
            for i in a {
                dotLabels[i]!.removeFromSuperview()
                deck[i] = nil
                shapeLayers[i]!.removeFromSuperlayer()
            }
            
            delay(bySeconds: 2.0) {
                for i in 0...4 {
                    if self.displayLabels[i].isDescendant(of: self.view) {
                        self.displayLabels[i].removeFromSuperview()
                        self.displayLayers[i].removeFromSuperlayer()
                    }
                }
                
                
                self.scoreFlash.text = self.additionalScoreString
                self.scoreFlash.alpha = 0
                self.view.addSubview(self.scoreFlash)
                UIView.animate(withDuration: 0.5, animations: {
                    self.scoreFlash.alpha = 1.0
                })
                _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(VsViewController.scoreFlashEndAI), userInfo: nil, repeats: false)
                if self.thisTurn == .red {
                    self.redPointsInt += self.additionalScoreInt
                } else {
                    self.yellowPointsInt += self.additionalScoreInt
                }
            }
        } else {
            print("nomoremoves2")
            noMoreMoves()
            bar.removeFromSuperview()
            
        }
    }
    
    
    @objc private func scoreFlashEnd() {
        UIView.animate(withDuration: 0.5, animations: {
            self.scoreFlash.alpha = 0.0
        })
        
        
        if ticker < 1001 {
            if thisTurn == .red {
                redScore.text = redPointsString
            } else {
                yellowScore.text = yellowPointsString
            }
            
            switch thisTurn {
            case .red:
                if oneTurnAgo == .start {
                    thisTurn = .yellow
                    if bar.isDescendant(of: view) {
                        bar.removeFromSuperview()
                    }
                    ticker = 0
                    
                    oneTurnAgo = .red
                    if tagLevelIdentifier == 1000 {
                        aISequence()
                    }
                } else if oneTurnAgo == .red {
                    thisTurn = .yellow
                    if bar.isDescendant(of: view) {
                        bar.removeFromSuperview()
                    }
                    ticker = 0
                    
                    timerBool = true
                    
                    twoTurnsAgo = .red
                    if tagLevelIdentifier == 1000 {
                        aISequence()
                    }
                } else {
                    thisTurn = .red //change to .red if you want two turns per player
                    twoTurnsAgo = .yellow
                }
                
                oneTurnAgo = .red
                
            case .yellow:
                if twoTurnsAgo == .start {
                    thisTurn = .yellow
                    twoTurnsAgo = .red
                    oneTurnAgo = .yellow
                    if tagLevelIdentifier == 1000 {
                        aISequence()
                    }
                } else if oneTurnAgo == .yellow {
                    thisTurn = .red
                    if bar.isDescendant(of: view) {
                        bar.removeFromSuperview()
                    }
                    ticker = 0
                    
                    timerBool = true
                    
                    twoTurnsAgo = .yellow
                } else {
                    thisTurn = .yellow //change to .yellow if you want two turns per player
                    twoTurnsAgo = .red
                    if tagLevelIdentifier == 1000 {
                        aISequence()
                    }
                }
                
                oneTurnAgo = .yellow
                
            case .start: break
            }
            
            if thisTurn == .red {
                redScore.frame = CGRect(x: (300/750)*screenWidth, y: (1180/1334)*screenHeight, width: (400/750)*screenWidth, height: (106/750)*screenWidth)
                redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*55)
                yellowScore.frame = CGRect(x: (49/750)*screenWidth, y: (1230/1334)*screenHeight, width: (150/750)*screenWidth, height: (60/750)*screenWidth)
                yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
            } else {
                yellowScore.frame = CGRect(x: (54/750)*screenWidth, y: (1180/1334)*screenHeight, width: (400/750)*screenWidth, height: (106/750)*screenWidth)
                yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*55)
                redScore.frame = CGRect(x: (565/750)*screenWidth, y: (1230/1334)*screenHeight, width: (150/750)*screenWidth, height: (60/750)*screenWidth)
                redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
            }
            if thisTurn == .yellow && tagLevelIdentifier == 1000 {
                //nothing
            } else {
                swipeChoices()
            }
        }
    }
    
    @objc private func scoreFlashEndAI() {
        print("scoreFlashEndAIFunc")
        UIView.animate(withDuration: 0.5, animations: {
            self.scoreFlash.alpha = 0.0
        })
        // scoreFlash.removeFromSuperview()
        if thisTurn == .red {
            redScore.text = redPointsString
        } else {
            yellowScore.text = yellowPointsString
        }
        switch thisTurn {
        case .red:
            if oneTurnAgo == .start {
                thisTurn = .yellow
                oneTurnAgo = .red
                if tagLevelIdentifier == 1000 {
                    aISequence()
                }
            } else if oneTurnAgo == .red {
                thisTurn = .yellow
                timerBool = true
                ticker = 0
                twoTurnsAgo = .red
                if tagLevelIdentifier == 1000 {
                    aISequence()
                }
            } else {
                thisTurn = .red
                twoTurnsAgo = .yellow
            }
            
            oneTurnAgo = .red
            
        case .yellow:
            if twoTurnsAgo == .start {
                thisTurn = .yellow
                twoTurnsAgo = .red
                oneTurnAgo = .yellow
                if tagLevelIdentifier == 1000 {
                    aISwipe()
                }
            } else if oneTurnAgo == .yellow {
                thisTurn = .red
                timerBool = true
                ticker = 0
                twoTurnsAgo = .yellow
                if tagLevelIdentifier == 1000 {
                    aITurnEnd()
                }
            } else {
                thisTurn = .yellow
                twoTurnsAgo = .red
                if tagLevelIdentifier == 1000 {
                    aISwipe()
                }
            }
            
            oneTurnAgo = .yellow
            
        case .start: break
        }
        
        if thisTurn == .red {
            redScore.frame = CGRect(x: (300/750)*screenWidth, y: (1180/1334)*screenHeight, width: (400/750)*screenWidth, height: (106/750)*screenWidth)
            redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*55)
            yellowScore.frame = CGRect(x: (49/750)*screenWidth, y: (1230/1334)*screenHeight, width: (150/750)*screenWidth, height: (60/750)*screenWidth)
            yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        } else {
            yellowScore.frame = CGRect(x: (54/750)*screenWidth, y: (1180/1334)*screenHeight, width: (400/750)*screenWidth, height: (106/750)*screenWidth)
            yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*55)
            redScore.frame = CGRect(x: (565/750)*screenWidth, y: (1230/1334)*screenHeight, width: (150/750)*screenWidth, height: (60/750)*screenWidth)
            redScore.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        }
        
        if thisTurn == .yellow && tagLevelIdentifier == 1000 {
            //nothing
        } else {
            swipeChoices()
        }
        
        
        
    }
    
    
    var myTimer = Timer()
    var startVisual = Timer()
    func startTimer() {
        dynamicBarCue = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(VsViewController.updateBar), userInfo: nil, repeats: true)
    }
    
    
    
    
    
    func stopTimer() {
        dynamicBarCue.invalidate()
        if bar.isDescendant(of: view) {
            bar.removeFromSuperview()
        }
    }
    
    
    let bar = UILabel()
    @objc private func updateBar() {
        if ticker == 700 {
            timerRanOutOn = thisTurn
            bar.frame = CGRect(x: (CGFloat(1)-percentageOfBar)*(screenWidth/2), y: (1319/1334)*screenHeight, width: screenWidth*percentageOfBar, height: (15/1334)*screenHeight)
            bar.backgroundColor = myColor.blue
            
            view.addSubview(bar)
        }
        if ticker == 1000 {
            timerRanOut()
            
            bar.removeFromSuperview()
        } else if ticker > 700 {
            percentageOfBar = CGFloat(1 - (ticker - 700)/300)
            
            bar.frame = CGRect(x: (CGFloat(1)-percentageOfBar)*(screenWidth/2), y: (1319/1334)*screenHeight, width: screenWidth*percentageOfBar, height: (15/1334)*screenHeight)
        }
        ticker += 1
        
    }
    @objc private func timerRanOut() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.view.removeGestureRecognizer(self.swipeRight as UIGestureRecognizer)
        self.view.removeGestureRecognizer(self.swipeLeft as UIGestureRecognizer)
        self.view.removeGestureRecognizer(self.swipeDown as UIGestureRecognizer)
        self.view.removeGestureRecognizer(self.pan as UIGestureRecognizer)
        
        delay(bySeconds: 2.0) {
            self.dropRight(currentDeck: self.deck)
            if self.bar.isDescendant(of: self.view) {
                self.bar.removeFromSuperview()
            }
            self.delay(bySeconds: 0.5) {
                self.dropLeft(currentDeck: self.deck)}
            self.handIndexes.removeAll()
            self.delay(bySeconds: 1.0) {
                switch self.timerRanOutOn {
                case .red:
                    if self.tagLevelIdentifier != 1000 {
                        self.view.addGestureRecognizer(self.pan)
                        
                    }
                    
                    self.thisTurn = .yellow
                    self.timerBool = true
                    self.ticker = 0
                    
                    self.oneTurnAgo = .red
                    self.twoTurnsAgo = .red
                    if self.tagLevelIdentifier == 1000 {
                        self.aISequence()
                    }
                    
                case .yellow:
                    self.view.addGestureRecognizer(self.pan)
                    self.thisTurn = .red
                    self.timerBool = true
                    self.ticker = 0
                    
                    self.twoTurnsAgo = .yellow
                    self.oneTurnAgo = .yellow
                    
                case .start: break
                    
                }
                
                if self.imageView.isDescendant(of: self.view) {
                    self.imageView.removeFromSuperview()
                }
                
                
                if self.thisTurn == .red {
                    self.redScore.frame = CGRect(x: (300/750)*self.screenWidth, y: (1180/1334)*self.screenHeight, width: (400/750)*self.screenWidth, height: (106/750)*self.screenWidth)
                    self.redScore.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSizeMultiplier*55)
                    self.yellowScore.frame = CGRect(x: (49/750)*self.screenWidth, y: (1230/1334)*self.screenHeight, width: (150/750)*self.screenWidth, height: (60/750)*self.screenWidth)
                    self.yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSizeMultiplier*20)
                } else {
                    self.yellowScore.frame = CGRect(x: (54/750)*self.screenWidth, y: (1180/1334)*self.screenHeight, width: (400/750)*self.screenWidth, height: (106/750)*self.screenWidth)
                    self.yellowScore.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSizeMultiplier*55)
                    self.redScore.frame = CGRect(x: (565/750)*self.screenWidth, y: (1230/1334)*self.screenHeight, width: (150/750)*self.screenWidth, height: (60/750)*self.screenWidth)
                    self.redScore.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSizeMultiplier*20)
                }
            }
        }
    }
    
    func addButtons() {
        addLabel(name: yellowScore, text: currentScoreString, textColor: myColor.yellow, textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 20, x: 49, y: 1230, width: 150, height: 60, lines: 0)
        // red score label
        addLabel(name: redScore, text: currentScoreString, textColor: myColor.pink, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 55, x: 300, y: 1180, width: 400, height: 106, lines: 0)
        //back button
        addButton(name: back, x: 59, y: 594, width: 633, height: 85, title: "Resume Game", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.back(_:)), addSubview: false)
        //sequencebutton
        addButton(name: sequence, x: 59, y: 460, width: 633, height: 85, title: "Sequences", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.sequence(_:)), addSubview: false)
        //sequence label
        addLabel(name: sequences, text: "Sequences", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 50, x: 0, y: 100, width: 750, height: 110, lines: 0)
        //Menux Button (transition in exiting game)
        addButton(name: menuX, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(VsViewController.menuX(_:)), addSubview: false)
        //Menux2 Button (transition in exiting game)
        addButton(name: menuX2, x: 0, y: 0, width: 116, height: 122, title: "", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(VsViewController.menuX2(_:)), addSubview: false)
        menuX2.setImage(#imageLiteral(resourceName: "menu215"), for: .normal)
        //Exit Button
        addButton(name: exit, x: 50, y: 1145, width: 650, height: 87, title: "Exit", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.exit(_:)), addSubview: false)
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
        stopTimer()
        view.addSubview(back)
        view.bringSubview(toFront: back)
        view.addSubview(menuX2)
        view.bringSubview(toFront: menuX2)
        for dot in dotLabels {
            dot?.alpha = 0.0
            dot?.layer.zPosition = 0
        }
        
        
    }
    @objc private func menuX2(_ button: UIButton) {
        
        self.performSegue(withIdentifier: "fromVsToIntro", sender: self)
        
    }
    
    
    @objc private func hint(_ button: UIButton) {
        
    }
    
    
    @objc private func back(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.sequence.removeFromSuperview()
        self.back.removeFromSuperview()
        self.menuX2.removeFromSuperview()
        startTimer()
        for dot in dotLabels {
            dot?.alpha = 1.0
            dot?.layer.zPosition = 1
        }
        
    }
    
    @objc private func sequence(_ button: UIButton) {
        
        self.sequence.removeFromSuperview()
        self.back.removeFromSuperview()
        
        view.addSubview(sequences)
        view.addSubview(showList)
        view.addSubview(sequenceRowOne)
        view.addSubview(sequenceRowTwo)
        view.addSubview(exit)
    }
    
    
    
}
