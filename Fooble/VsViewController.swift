//
//  VsViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/3/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import UIKit
import AudioToolbox

class VsViewController: UIViewController {
    
    var a = [Int]()
    var p = Int()
    var center = Int()
    var centerPoint = CGPoint()
    var panTouchLocation = CGPoint()
    var locationOfBeganPan = CGPoint()
    var locationOfEndPan = CGPoint()
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
    let exit = UIButton()
    
    let scoreFlash = UILabel()
    var displayLayers = [CAShapeLayer]()
    var shapeLayers = [CAShapeLayer?]()
    var shapeLayers2 = [CAShapeLayer]()
    var yellowPointsInt = Int() {didSet{yellowPointsString = String(yellowPointsInt)}}
    var yellowPointsString = "Score"
    var redPointsInt = Int() {didSet{redPointsString = String(redPointsInt)}}
    var redPointsString = "Score"
    let sequence = UIButton()
    let sequences = UILabel()
    let back = UIButton()
    let exitSequences = UIButton()
    let showList = UIButton()
    let yellowScore = UILabel()
    let redScore = UILabel()
    var hintDisplay = [CAShapeLayer]()
    var hintNumbersAsStrings = [String]()
    var hintNumberLabels = [UILabel]()
    var tagLevelIdentifier = Int()
    let menuX = UIButton()
    let menuX2 = UIButton()
    let menuBox = UIButton()
    let sequenceRowOne = UILabel()
    let sequenceRowTwo = UILabel()
    let dotNumbersAsStrings = [String]()
    var dotLabels = [UILabel?]()
    var displayLabels = [UILabel]()
    var additionalScoreString: String = "0"
    var additionalScoreInt = Int() {didSet{additionalScoreString = String(additionalScoreInt)}}
    var deck = [Int?]()
    var myShuffleAndDeal = ShuffleAndDeal()
    let mySelection = Selection()
    let myCalculator = Calculator()
    let myNarrative = Narrative()
    let myLoadSaveCoreData = LoadSaveCoreData()
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
    var pan = UIPanGestureRecognizer()
    var imageView = UIImageView()
    var dynamicBarCue = Timer()
    var ticker: Float = 0.0 //{didSet { print(ticker)}}
    var percentageOfBar: CGFloat = 1.0
    var shuffled = [Int]()
    var allNumbers = [Int]()
    var test = false
    var timerRanOutOn: Team = .red
    let myColor = PersonalColor()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
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
            let linewidth = 2.0*screenWidth/750
            shapeLayers[i]!.lineWidth = linewidth
            dotLabels[i]!.text = String(deck[i]!%7 + 1)
            view.layer.addSublayer(shapeLayers[i]!)
            self.view.addSubview(dotLabels[i]!)
        }
        
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
            outerloop: if gesture.state == UIGestureRecognizerState.changed {
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
        backBlack.alpha = 0.9
        view.addSubview(backBlack)
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
            if self.dotLabels[30] == nil && self.dotLabels[31] == nil {
                let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)}
            if !self.myAllPossibilities.stopEverything {
                self.noMoreMoves()
                print("nomoremoves3")
                
                self.bar.removeFromSuperview()
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
                shapeLayers[a[i]]!.strokeColor = myColor.pink.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom2:
                shapeLayers[a[i]]!.strokeColor =  myColor.yellow.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom3:
                shapeLayers[a[i]]!.strokeColor =  myColor.blue.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
            case .custom4:
                shapeLayers[a[i]]!.strokeColor = myColor.white.cgColor
                delay(bySeconds: 1.0, closure: {self.view.layer.addSublayer(self.shapeLayers[self.a[i]]!)})
                
                
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
    
    private func dropLeft(currentDeck: [Int?]) {
        print("dropleftfunc")
        while isDropInProgress {
            
        }
        isDropInProgress = true
        delay(bySeconds: 0.2) { while self.trackerSum != self.trackerSumPrior || self.bool {
            
            self.trackerSumPrior = self.trackerSum
            //
            for i in self.iReverse {
                
                if i != 7 && i != 22 && i != 37 && i != 52 {
                    
                    if self.deck[i] != nil {
                        
                        if self.deck[i+7] == nil {
                            UIView.animate(withDuration: 0.17, animations: {
                                self.dotLabels[i]!.frame.origin.x -= self.dotSize
                            })
                            UIView.animate(withDuration: 0.17, animations: {
                                self.dotLabels[i]!.frame.origin.y += 2*self.dotSize
                            })
                            
                            
                            self.dotLabels[i+7] = self.dotLabels[i]!
                            self.dotLabels[i] = nil
                            //                        UIView.animate(withDuration: 0.5, animations: {
                            self.shapeLayers[i]!.frame.origin.x -= self.dotSize
                            //                        })
                            //                        UIView.animate(withDuration: 0.5, animations: {
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
                            //                        })
                            
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
        
        
        
    }
    
    private func dropRight(currentDeck: [Int?]) {
        print("droprightfunc")
        while isDropInProgress {
            
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
                            //                        UIView.animate(withDuration: 0.5, animations: {
                            self.shapeLayers[i]!.frame.origin.x += self.dotSize
                            //                        })
                            
                            //                        UIView.animate(withDuration: 0.5, animations: {
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
                            //                        })
                            
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
                    shapeLayers[i]!.strokeColor = myColor.pink.cgColor
                    
                    case .custom2:
                    shapeLayers[i]!.strokeColor = myColor.yellow.cgColor
                    
                    case .custom3:
                    shapeLayers[i]!.strokeColor = myColor.blue.cgColor
                    
                    case .custom4:
                    shapeLayers[i]!.strokeColor = myColor.white.cgColor
                    
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
       
            print("scoreFlashEndFunc")
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
                    thisTurn = .yellow
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
            bar.backgroundColor = myColor.background
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
        
        // black background
        backBlack.backgroundColor = myColor.background
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        //scoreFlash label
        addLabel(name: scoreFlash, text: additionalScoreString, textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 70, x: 0, y: 88, width: 750, height: 110, lines: 0)
        if tagLevelIdentifier > 99 {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*70)
        } else {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*50)
        }
        
        //back button
        addButton(name: back, x: 59, y: 594, width: 633, height: 85, title: "Resume Game", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.back(_:)), addSubview: false)

        
        
        
        //sequencebutton
        addButton(name: sequence, x: 59, y: 460, width: 633, height: 85, title: "Sequences", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.sequence(_:)), addSubview: false)
        //sequence label
        addLabel(name: sequences, text: "Sequences", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 50, x: 0, y: 100, width: 750, height: 110, lines: 0)

        addLabel(name: yellowScore, text: currentScoreString, textColor: UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0), textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 55, x: 300, y: 1180, width: 400, height: 106, lines: 0)
        // red score label
        addLabel(name: redScore, text: currentScoreString, textColor: myColor.red, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 36, x: 450, y: 1231, width: 250, height: 46, lines: 0)

        //Menux Button (transition in exiting game)
        addButton(name: menuX, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(VsViewController.menuX(_:)), addSubview: false)
        //Menux2 Button (transition in exiting game)
        addButton(name: menuX2, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(VsViewController.menuX2(_:)), addSubview: false)
        //sequence row two label
        addLabel(name: sequenceRowTwo, text: "50\n100\n150\n500\n750\n1500\n2500\n3500\n5,000\n10,000\n20,000\n", textColor: myColor.offWhite, textAlignment: .right, fontName: "HelveticaNeue-Bold", fontSize: 20, x: 173, y: 262, width: 500, height: 750, lines: 0)
        //sequence row one label
        addLabel(name: sequenceRowOne, text: "Pair\n3 Flush\n3 Straight\n3 of a Kind\n3 Straight Flush\n5 Straight\n5 Flush\n5 Full House\n4 of a Kind\n5 of a Kind\n5 Straight Flush", textColor: myColor.offWhite, textAlignment: .left, fontName: "HelveticaNeue-Bold", fontSize: 20, x: 80, y: 237, width: 500, height: 750, lines: 0)
        //Exit Button
        addButton(name: exit, x: 50, y: 1145, width: 650, height: 87, title: "Exit", font: "HelveticaNeue-Bod", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(VsViewController.exit(_:)), addSubview: false)
        
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
            dotLabel.layer.zPosition = 1
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
        view.addSubview(menuX2)
        
        
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
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
}
