//
//  AllPossibilities.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 1/4/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct AllPossibilities {
    
    var allHands = [[Int]]()
    var allHandsIndexes = [[Int]]()
    var allNilIndexes = [Int]()
    let mySelection = Selection()
    let myCalculator = Calculator()
    var highScoreIndex: Int = 0
    var lastScore: Int? = 0
    var handScore: Int?
    var stopEverything = true
    
    
    //    mutating func calculateNumberOfMovesLeft(deck: [Int?]) -> Int {
    //
    //    }
    
    
    mutating func calculateBestHandIndexes(deck: [Int?]) -> [Int] {
        var nextIndexes = [Int]()
        var twoCardHands = [[Int]]()
        var threeCardHands = [[Int]]()
        var fourCardHands = [[Int]]()
        var fiveCardHands = [[Int]]()
        var allHands = [[Int]]()
        var points = [Int]()
        var keepGoing = true
        
        for i in 0..<67 {  //five carded hands by their index
            if deck[i] != nil {
                
                nextIndexes =  mySelection.selectableIndexesWithOneAlreadySelected(first: i)
                for n in nextIndexes {
                    if deck[n] != nil {
                        var m = Int()
                        m = mySelection.linearCheckForNumberAfterLast(last: n, prior: i)
                        var futureRow = mySelection.thisRow(index: m)
                        let lastRow = mySelection.thisRow(index: n)
                        switch n {
                        case 6,14,21,29,36,44,51,59:
                            if m == n + 1 {
                                futureRow = lastRow + 2
                            }
                        case 7,15,22,30,37,45,52,60:
                            if m == n - 1 {
                                futureRow = lastRow + 2
                            }
                        default: break
                        }
                        if m < 67 && m > -1 {
                            if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[m] != nil {
                                
                                var o = Int()
                                o = mySelection.linearCheckForNumberAfterLast(last: m, prior: n)
                                var futureRow = mySelection.thisRow(index: o)
                                let lastRow = mySelection.thisRow(index: m)
                                switch m {
                                case 6,14,21,29,36,44,51,59:
                                    if o == m + 1 {
                                        futureRow = lastRow + 2
                                    }
                                case 7,15,22,30,37,45,52,60:
                                    if o == m - 1 {
                                        futureRow = lastRow + 2
                                    }
                                default: break
                                }
                                if o < 67 && o > -1 {
                                    if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[o] != nil {
                                        
                                        var p = Int()
                                        p = mySelection.linearCheckForNumberAfterLast(last: o, prior: m)
                                        var futureRow = mySelection.thisRow(index: p)
                                        let lastRow = mySelection.thisRow(index: o)
                                        switch o {
                                        case 6,14,21,29,36,44,51,59:
                                            if p == o + 1 {
                                                futureRow = lastRow + 2
                                            }
                                        case 7,15,22,30,37,45,52,60:
                                            if p == o - 1 {
                                                futureRow = lastRow + 2
                                            }
                                        default: break
                                        }
                                        if p < 67 && p > -1 {
                                            if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[p] != nil {
                                                let score = myCalculator.pointAmount(hand: myCalculator.reorderHand(hand: [deck[i]!,deck[m]!,deck[n]!,deck[o]!,deck[p]!]))
                                                if score > 0 {
                                                    fiveCardHands.append([i,n,m,o,p])
                                                    allHands.append([i,n,m,o,p])
                                                    points.append(score)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        
        
        for i in 0..<67 {  //four carded hands by their index
            if deck[i] != nil {
                
                nextIndexes =  mySelection.selectableIndexesWithOneAlreadySelected(first: i)
                for n in nextIndexes {
                    if deck[n] != nil {
                        var m = Int()
                        m = mySelection.linearCheckForNumberAfterLast(last: n, prior: i)
                        var futureRow = mySelection.thisRow(index: m)
                        let lastRow = mySelection.thisRow(index: n)
                        switch n {
                        case 6,14,21,29,36,44,51,59:
                            if m == n + 1 {
                                futureRow = lastRow + 2
                            }
                        case 7,15,22,30,37,45,52,60:
                            if m == n - 1 {
                                futureRow = lastRow + 2
                            }
                        default: break
                        }
                        if m < 67 && m > -1 {
                            if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[m] != nil {
                                
                                var o = Int()
                                o = mySelection.linearCheckForNumberAfterLast(last: m, prior: n)
                                var futureRow = mySelection.thisRow(index: o)
                                let lastRow = mySelection.thisRow(index: m)
                                switch m {
                                case 6,14,21,29,36,44,51,59:
                                    if o == m + 1 {
                                        futureRow = lastRow + 2
                                    }
                                case 7,15,22,30,37,45,52,60:
                                    if o == m - 1 {
                                        futureRow = lastRow + 2
                                    }
                                default: break
                                }
                                if o < 67 && o > -1 {
                                    if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[o] != nil {
                                        let score = myCalculator.pointAmount(hand: myCalculator.reorderHand(hand: [deck[i]!,deck[m]!,deck[n]!,deck[o]!]))
                                        if score > 0 {
                                            fourCardHands.append([i,n,m,o])
                                            allHands.append([i,n,m,o])
                                            points.append(score)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        if fiveCardHands.count > 0 || fourCardHands.count > 0 {
            keepGoing = false
        }
        if keepGoing {
            for i in 0..<67 {  //three carded hands by their index
                if deck[i] != nil {
                    
                    nextIndexes =  mySelection.selectableIndexesWithOneAlreadySelected(first: i)
                    for n in nextIndexes {
                        if deck[n] != nil {
                            var m = Int()
                            m = mySelection.linearCheckForNumberAfterLast(last: n, prior: i)
                            var futureRow = mySelection.thisRow(index: m)
                            let lastRow = mySelection.thisRow(index: n)
                            switch n {
                            case 6,14,21,29,36,44,51,59:
                                if m == n + 1 {
                                    futureRow = lastRow + 2
                                }
                            case 7,15,22,30,37,45,52,60:
                                if m == n - 1 {
                                    futureRow = lastRow + 2
                                }
                            default: break
                            }
                            if m < 67 && m > -1 {
                                if (lastRow == futureRow - 1 || lastRow == futureRow + 1) && deck[m] != nil {
                                    let score = myCalculator.pointAmount(hand: myCalculator.reorderHand(hand: [deck[i]!,deck[m]!,deck[n]!]))
                                    if score > 0 {
                                        threeCardHands.append([i,n,m])
                                        allHands.append([i,n,m])
                                        points.append(score)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                
            }
            
            
            for i in 0..<67 {  //two card hands by their index
                if deck[i] != nil {
                    
                    nextIndexes = mySelection.selectableIndexesWithOneAlreadySelected(first: i)
                    for n in nextIndexes {
                        if deck[n] != nil {
                            if deck[i]!%7 == deck[n]!%7 {
                                twoCardHands.append([i,n])
                                allHands.append([i,n])
                                points.append(50)
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        // pick bad score third of time
        
        let randomNumber = Int(arc4random_uniform(3))
        
        if randomNumber == 0 {
            print("option1")
            if allHands.count > 0 {
                print("1")
                let randomNumber2 = Int(arc4random_uniform(UInt32(allHands.count)))
                
                lastScore = points[randomNumber2]
                highScoreIndex = randomNumber2
                
                
                
                
            } else {
                print("2")
                allHands = [[0],[0],[0]] //filler that's never used because stopeverything is called
                stopEverything = false
            }
            handScore = lastScore
            
            
            
        } else {
            print("option2")
            if allHands.count > 0 {
                print("3")
                
                lastScore = points.max()!
                for i in 0..<points.count {
                    print("4")
                    if lastScore == points[i] {
                        print("5")
                        highScoreIndex = i
                    }
                }
            } else {
                print("6")
                allHands = [[0],[0],[0]] //filler that's never used because stopeverything is called
                stopEverything = false
                highScoreIndex = 1
            }
            handScore = lastScore
        }
        
        
        keepGoing = true
        print("counts")
        print(allHands.count)
        print(allHands)
        print(points.count)
        print(points)
        print("deck: \(deck)")
        print(allHands[highScoreIndex])
        print(stopEverything)
        return allHands[highScoreIndex]  // what if allHands are nil and I try calling allHands[0], when using this function make sure to check for a lastscore first, if no score then there are no moves left and the allHands array is outputting [0,0]
    }
    
    
}
