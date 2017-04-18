//
//  GameViewController.swift
//  Ransom!
//
//  Created by Aaron Halvorsen on 12/28/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//
import UIKit
import GCHelper
import Intro

class GameViewController: GameSetupViewController {
    
    var seg = "nothing"
    var passedLevel = Bool()
    var panTouchLocation = CGPoint()
    var futureIndexes = [Int]()
    var priorIndex = Int()
    var lastIndex = Int()
    let myNarrative = Narrative()
        let myGameCenter = GameCenter()
    var isFirst = true
    
    
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
        addLabels()
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
    
    override func viewWillAppear(_ animated: Bool) {
        populateDotsExtended()
        if tagLevelIdentifier == 1 && isFirst {
            isFirst = false
            let vc = IntroViewController()
            vc.items = [
                ("Form sequences by swiping horizontally or diagonally. For Example: These 5s = Four Of A Kind!", UIImage(named: "Tutorial1.png")),
                ("Tap on labels to see example sequences", UIImage(named: "Tutorial2.png")),
                ("Try player vs player, player vs iphone, and Game Center modes too!", UIImage(named: "Tutorial3.png"))
            ]
            vc.animationType = .rotate
            vc.titleColor = .black
          //  vc.titleFont = .systemFont(ofSize: 20)
           // vc.imageContentMode = .scaleAspectFit
            vc.closeTitle = "READY"
            vc.closeColor = .black
            vc.closeBackgroundColor = .clear
            vc.closeBorderWidth = 1
            vc.closeBorderColor = UIColor.black.cgColor
            vc.closeCornerRadius = 4
//            vc.didClose = {
//                self.showButton.setTitle("Show again", for: .normal)
//            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {self.view.alpha = 0.9}
        print("tagLevelIdentifier: \(tagLevelIdentifier)")
        if tagLevelIdentifier > 99 {
            GCHelper.sharedInstance.authenticateLocalUser()
        }
        

    }
    
    
    private func populateDotsExtended() {
        if tagLevelIdentifier == 100 {
            for dot in dotLabels {
                dot?.layer.zPosition = 0
            }
            displayTutorial()
            menuX.removeFromSuperview()
        } else if tagLevelIdentifier == 1 {
            displayTutorialForCampaign()
        } else {
            view.addSubview(menuX)
            

        }
    }
    
 
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
                    self.delay(bySeconds: 0.25) {
                        self.view.addGestureRecognizer(self.pan)
                        self.delay(bySeconds: 0.6) {
                            
                            let _ = self.myAllPossibilities.calculateBestHandIndexes(deck: self.deck)}
                        print("checkall")
                        self.delay(bySeconds: 0.6) {
                            if !self.myAllPossibilities.stopEverything {
                                self.noMoreMoves()
                            }
                        }
                    }
                }
            }
        }
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
            view.subviews.forEach({ $0.removeFromSuperview() })
            view.addSubview(backBlack)
            sequences.text = "No More Moves"
            sequences.textColor = .black
            sequences.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
            sequences.layer.zPosition = 5
            view.addSubview(sequences)
            menuX.removeFromSuperview()
            menuX2.layer.zPosition = 5
            view.addSubview(menuX2)
            restart.layer.zPosition = 5
            restart.frame.origin.y = 1200*screenHeight/1334
            view.addSubview(restart)
            let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "ghostHurt")
            iv.frame = CGRect(x: screenWidth/4, y: 300*screenHeight/1334, width: screenWidth/2, height: screenWidth/2)
            view.addSubview(iv)
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
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.addSubview(menuBox)
        view.addSubview(finishMessage)
        myLoadSaveCoreData.saveLevel(tagLevelIdentifier: tagLevelIdentifier)
        if tagLevelIdentifier == 1 {
            myLoadSaveCoreData.saveDemo(mode: "Campaign")
        }
        let array = [1,4,9,17,25,33,37,40,41,42,43]
        if array.contains(tagLevelIdentifier) {
            let image = UIImage(named: "Princess.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: screenWidth/4, y: (300/1334)*screenHeight, width: screenWidth/2, height: screenWidth/2)
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
        
        //leaderboard button
        addButton(name: leaderboard, x: 59, y: 726, width: 633, height: 85, title: "Game Center", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.white, act: #selector(GameViewController.showGameCenterVC(_:)), addSubview: false)
        //restart button
        addButton(name: restart, x: 59, y: 324, width: 633, height: 85, title: "Restart", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.white, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.restart(_:)), addSubview: false)
        
        
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
        addLabel(name: tutorialAnnotation3, text: "", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 14, x: 100, y: 60, width: 550, height: 130, lines: 0)
        
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
        //back button
        addButton(name: back, x: 59, y: 594, width: 633, height: 85, title: "Resume Game", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.back(_:)), addSubview: false)
        //sequencebutton
        addButton(name: sequence, x: 59, y: 460, width: 633, height: 85, title: "Sequences", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.sequence(_:)), addSubview: false)
        //sequence label
        addLabel(name: sequences, text: "Sequences", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 50, x: 0, y: 100, width: 750, height: 110, lines: 0)
        //Menux Button (transition in exiting game)
        addButton(name: menuX, x: 25, y: 25, width: 50, height: 50, title: "X", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GameViewController.menuX(_:)), addSubview: false)
        //Menux2 Button (transition in exiting game)
        addButton(name: menuX2, x: 0, y: 0, width: 116, height: 122, title: "", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 0, boarderColor: .clear, act: #selector(GameViewController.menuX2(_:)), addSubview: false)
        menuX2.setImage(#imageLiteral(resourceName: "menu215"), for: .normal)
        //Exit Button
        addButton(name: exit, x: 50, y: 1145, width: 650, height: 87, title: "Exit", font: "HelveticaNeue-Bold", fontSize: 30, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 5, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(GameViewController.exit(_:)), addSubview: false)
    }
    
    
    @objc private func exit(_ button: UIButton) {
        self.backBlack.removeFromSuperview()
        self.sequences.removeFromSuperview()
        self.showList.removeFromSuperview()
        self.sequenceRowTwo.removeFromSuperview()
        self.sequenceRowOne.removeFromSuperview()
        self.menuX2.removeFromSuperview()
        self.exit.removeFromSuperview()
        for dot in dotLabels {
            dot?.layer.zPosition = 1
        }
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
        for dot in dotLabels {
            dot?.layer.zPosition = 0
        }
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
        for dot in dotLabels {
            dot?.layer.zPosition = 0
        }
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
        for dot in dotLabels {
            dot?.layer.zPosition = 2
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
        for dot in dotLabels {
            dot?.layer.zPosition = 1
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
        for dot in dotLabels {
            dot?.layer.zPosition = 1
        }
        
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
        addLabels()
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
        for dot in dotLabels {
            dot?.layer.zPosition = 1
        }
    }
    
    private func displayTutorial() {
        
        view.addSubview(backBlack)
        view.addSubview(tutorialAnnotation)
        view.addSubview(sequenceRowOne)
        view.addSubview(sequenceRowTwo)
        view.addSubview(okay)
    }
    
    private func displayTutorialForCampaign() {
    
        view.addSubview(tutorialAnnotation3)
       
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
