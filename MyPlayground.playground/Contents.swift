//: Playground - noun: a place where people can play

import UIKit

var shuffledDeck = [Int]()
var levelDeals = [[Int]]()

for _ in 0..<43 {

var allNumbers = [Int]()
for i in 0..<84 {
    allNumbers.append(i)
}
shuffledDeck.removeAll()
for _ in 0..<67 {
    let randomNumber = Int(arc4random_uniform(UInt32(allNumbers.count)))
    if let index = allNumbers.index(of: allNumbers[randomNumber]) {
        shuffledDeck.append(allNumbers[randomNumber])
        allNumbers.remove(at:index)
    }
}
    levelDeals.append(shuffledDeck)
}
print(levelDeals)
