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
        let orderedHand = _hand.sorted { $0 < $1 }
        
        return orderedHand
    }
    func questString(hand: [Int]) -> String {
        var quest = String()
        var numbers = [Int]()
        for i in hand {
            numbers.append(i%7)
        }
        numbers = numbers.sorted { $0 < $1 }
        
        if hand.count == 0 || hand.count == 1 {
            quest = ""
        }
        if hand.count == 2 {
            if numbers[0] == numbers[1] {
                quest = "Pair"
            }
        }
        if hand.count == 3 {
            if whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[1]) && whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[2]) {
                if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                    quest = "3 Str. Flush"
                } else {
                    quest = "3 Flush"
                }
            } else if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                quest = "3 Straight"
            } else if numbers[2] == numbers[1] && numbers[2] == numbers[0] {
                quest = "3 Kind"
            }
        }
        
        if hand.count == 4 {
            if numbers[2] == numbers[1] && numbers[2] == numbers[0] {
                if numbers[2] == numbers[3] {
                    quest = "4 Kind"
                }
            }
        }
        
        if hand.count == 5 {
          
            
            var b = false
            var c = false
            var d = false
            if whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[1]) && whatColorIsCard(card: hand[1]) == whatColorIsCard(card: hand[2]) { b = true }
            if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] { c = true}
            if numbers[4] == numbers[3] && numbers[3] == numbers[2] { d = true }
            
            if whatColorIsCard(card: hand[2]) == whatColorIsCard(card: hand[3]) && whatColorIsCard(card: hand[3]) == whatColorIsCard(card: hand[4]) && b {
                
                if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] {
                   
                    if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                       
                        quest = "5 Str. Flush"
                    } else {
                    
                        quest = "5 Flush"
                    }
                } else {
              
                    quest = "5 Flush"
                }
            } else if c && numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
             
                quest = "5 Sraight"
            } else if d && numbers[2] == numbers[1] && numbers[1] == numbers[0] {
         
                quest = "5 Kind"
            } else if numbers[4] == numbers[3] && numbers[1] == numbers[0] {
          
            
                if numbers[2] == numbers[3] || numbers[2] == numbers[1] {
              
                    quest = "5 Full House"
                }
                
                
            }
            
            
        }
        return quest
    }
    
    func pointAmount(hand: [Int]) -> Int {
        var points = Int()
        var numbers = [Int]()
        for i in hand {
            numbers.append(i%7)
        }
        numbers = numbers.sorted { $0 < $1 }
  
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
       
            var b = false
            var c = false
            var d = false
            if whatColorIsCard(card: hand[0]) == whatColorIsCard(card: hand[1]) && whatColorIsCard(card: hand[1]) == whatColorIsCard(card: hand[2]) { b = true }
            if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] { c = true}
            if numbers[4] == numbers[3] && numbers[3] == numbers[2] { d = true }
            
            if whatColorIsCard(card: hand[2]) == whatColorIsCard(card: hand[3]) && whatColorIsCard(card: hand[3]) == whatColorIsCard(card: hand[4]) && b {
                
                if numbers[4] - 1 == numbers[3] && numbers[3] - 1 == numbers[2] {
                   
                    if numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
                       
                        points = 20000
                    } else {
                 
                        points = 2500
                    }
                } else {
            
                    points = 2500
                }
            } else if c && numbers[2] - 1 == numbers[1] && numbers[1] - 1 == numbers[0] {
      
                points = 1500
            } else if d && numbers[2] == numbers[1] && numbers[1] == numbers[0] {
          
                points = 10000
            } else if numbers[4] == numbers[3] && numbers[1] == numbers[0] {


                if numbers[2] == numbers[3] || numbers[2] == numbers[1] {

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

