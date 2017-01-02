//
//  Calculator.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 12/31/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//

import Foundation

class Calculator: ShuffleAndDeal {
    
    
    func reorderHand(hand: [Int]) -> [Int] { //reorders hand. melds into one deck to be compared and scored
        var _hand = hand
        var n = 0
        for i in hand {
            if i > 27 {
                if i < 56 {
                    _hand[n] -= 28
                } else if i < 84 {
                    _hand[n] -= 56
                } else if i < 112 {
                    _hand[n] -= 84
                } else if i < 140 {
                    _hand[n] -= 112
                }
            }
            n += 1
        }
        var orderedHand = _hand.sorted { $0 < $1 }
        var orderedAccordingToNumbers = [Int]()
        
        return orderedHand
    }
    
    func pointAmount(hand: [Int]) -> Int {
        var points = Int()
        var numbers = [Int]()
        for i in hand {
            numbers.append(i%7)
        }
        numbers = numbers.sorted { $0 < $1 }
        print("numbers: \(numbers)")
        if hand.count == 0 || hand.count == 1 {
            points = 0
        }
        if hand.count == 2 {
            if numbers[0] == numbers[1] {
                points = 50
            }
        }
        if hand.count == 3 {
            if whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[1]) && whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[2]) {
                if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                    points = 750
                } else {
                    points = 100
                }
            } else if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                points = 150
            } else if numbers[2] == numbers[1] && numbers[2] == numbers[0] {
                points = 500
            }
        }
        
        if hand.count == 4 {
            if numbers[2] == numbers[1] && numbers[2] == numbers[0] {
                if numbers[2] == numbers[3] {
                    points = 5000
                }
            }
        }
        
        if hand.count == 5 {
            print("0")
            var b = false
            var c = false
            var d = false
            if whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[1]) && whatColorIsCard(card: hand[1]) == whatColorIsCard(card: hand[2]) { b = true; print("1") }
            if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] { c = true; print("1") }
            if numbers[4] == numbers[3] && numbers[3] == numbers[2] { d = true; print("1") }
            
            if whatColorIsCard(card: hand[2]) == whatColorIsCard(card: hand[3]) && whatColorIsCard(card: hand[3]) == whatColorIsCard(card: hand[4]) && b { print("2")
                
                if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] {
                    print("3")
                    if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                        print("4")
                        points = 20000
                    } else {
                        print("5")
                        points = 2500
                    }
                } else {
                    print("6")
                    points = 2500
                }
            } else if c && numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                print("8")
                points = 1500
            } else if d && numbers[2] == numbers[1] && numbers[1] == numbers[0] {
                print("10")
                points = 10000
            } else if numbers[4] == numbers[3] && numbers[1] == numbers[0] {
                print("11")
                print("\(numbers[0]),\(numbers[1]),\(numbers[2]),\(numbers[3]),\(numbers[4])")
                if numbers[2] == numbers[3] || numbers[2] == numbers[1] {
                    print("12")
                    points = 3500
                }
                
                
            }
            
            
        }
        return points
    }
    
    
}

//2 Pair 50
//3 Flush 100
//3 Straight 150
//3 of a Kind 500
//3 Straight Flush 750
//5 Straight 1500
//5 Flush 2500
//5 Full House 3500
//4 of a Kind 5000
//5 of a Kind 10,000
//5 Straight Flush 20,000

