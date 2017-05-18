//
//  ExtensionUIViewController.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 2/13/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
// there is a gameVC for standard games and than a VsVC for iPhone Vs and player vs player. Common functions are stored in GameSetupVC that GameVC and VsVC inherit from

import UIKit

extension UIViewController {

    var screenWidth: CGFloat {get{return UIScreen.main.bounds.width}}
    var screenHeight: CGFloat {get{return UIScreen.main.bounds.height}}
    var fontSizeMultiplier: CGFloat {get{return UIScreen.main.bounds.width / 375}}
    var topMargin: CGFloat {get{return (269/1332)*UIScreen.main.bounds.height}}
}

class GameSetupViewController: UIViewController {
    var center = Int()
    var centerPoint = CGPoint()
    var locationOfBeganPan = CGPoint()
    var locationOfEndPan = CGPoint()
    var tagLevelIdentifier = Int()
    var frontMargin = CGFloat()
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
    let myLoadSaveCoreData = LoadSaveCoreData()
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

    
    func dropLeft(currentDeck: [Int?]) {
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
                            UIView.animate(withDuration: 0.10) {
                                self.dotLabels[i]!.frame.origin.x -= self.dotSize/2
                                self.dotLabels[i]!.frame.origin.y += self.dotSize
                            }
                            
                            UIView.animate(withDuration: 0.22) {
                                self.dotLabels[i]!.frame.origin.x -= self.dotSize/2
                                self.dotLabels[i]!.frame.origin.y += self.dotSize
                            }

                            self.dotLabels[i+7] = self.dotLabels[i]!
                            self.dotLabels[i] = nil
                            self.shapeLayers[i]!.frame.origin.x -= self.dotSize
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
                            self.shapeLayers[i+7] = self.shapeLayers[i]!
                            self.shapeLayers[i] = nil
                            self.deck[i+7] = self.deck[i]
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
    
    func dropRight(currentDeck: [Int?]) {
        
        while isDropInProgress {
            print("droprightfunc")
        }
        isDropInProgress = true
        
        delay(bySeconds: 0.2) {  while self.trackerSum != self.trackerSumPrior || self.bool {
            
            self.trackerSumPrior = self.trackerSum
            
            for i in self.iReverse {
                
                if i != 14 && i != 29 && i != 44 && i != 59 {
                    
                    if self.deck[i] != nil {
                        
                        if self.deck[i+8] == nil {
                            
                            UIView.animate(withDuration: 0.10, animations: {
                                self.dotLabels[i]!.frame.origin.x += self.dotSize/2
                                self.dotLabels[i]!.frame.origin.y += self.dotSize
                            })
                            
                            UIView.animate(withDuration: 0.22, animations: {
                                self.dotLabels[i]!.frame.origin.x += self.dotSize/2
                                self.dotLabels[i]!.frame.origin.y += self.dotSize
                            })
                            
                            self.dotLabels[i+8] = self.dotLabels[i]!
                            self.dotLabels[i] = nil
                            self.shapeLayers[i]!.frame.origin.x += self.dotSize
                            self.shapeLayers[i]!.frame.origin.y += 2*self.dotSize
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
    func addLabels() {
        

        
        //scoreFlash label
        addLabel(name: scoreFlash, text: additionalScoreString, textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 70, x: 0, y: 88, width: 750, height: 110, lines: 0)
        if tagLevelIdentifier > 99 {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*70)
        } else {
            scoreFlash.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*50)
        }
        
        
        
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
           // dotLabel.layer.borderWidth = 1.0
          //  dotLabel.layer.cornerRadius = 2
          //  dotLabel.clipsToBounds = true
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
            shapeLayer.strokeColor = UIColor.clear.cgColor
           
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
        // black background
        backBlack.backgroundColor = myColor.background
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
    }
    
    func populateDots() {
        lastCardDisplayed = 999
        for i in 0..<67 {
            
            switch myShuffleAndDeal.whatColorIsCard(card: deck[i]!) {
            case .custom1: //pink
                shapeLayers[i]!.strokeColor = UIColor(red: 249/255, green: 22/255, blue: 109/255, alpha: 1.0).cgColor
                
            case .custom2: //yellow
                shapeLayers[i]!.strokeColor = UIColor(red: 251/255, green: 214/255, blue: 50/255, alpha: 1.0).cgColor
                
            case .custom3: //blue
                shapeLayers[i]!.strokeColor = UIColor(red: 80/255, green: 189/255, blue: 252/255, alpha: 1.0).cgColor
                
            case .custom4: //white
                shapeLayers[i]!.strokeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
                
            }
            let linewidth = 3.0*screenWidth/750
            shapeLayers[i]!.lineWidth = linewidth
            dotLabels[i]!.text = String(deck[i]!%7 + 1)
            view.layer.addSublayer(shapeLayers[i]!)
            self.view.addSubview(dotLabels[i]!)
        }
        
        view.addSubview(menuX)
        
    }
    
    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
}
