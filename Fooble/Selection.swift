//
//  Selection.swift
//  Fooble
//
//  Created by Aaron Halvorsen on 12/31/16.
//  Copyright © 2016 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct Selection {
    
    func thisRow(index: Int) -> Int {
        var row = Int()
        switch index {
        case 0...6: row = 1
        case 7...14: row = 2
        case 15...21: row = 3
        case 22...29: row = 4
        case 30...38: row = 5
        case 38...45: row = 6
        case 46...52: row = 7
        case 53...60: row = 8
        case 61...67: row = 9
        default: break
        }
        
        return row
    }
  
    
    func linearCheckForNumberAfterLast(last: Int, prior: Int) -> Int {
        
        let index =  2*last - prior
        
        return index
        
    }
    
    func selectableIndexesWithOneAlreadySelected(first: Int) -> [Int] {
       var returnList = [Int]()
        switch first {
        case 0: let list = [1,7,8]; returnList = list
        case 1: let list = [0,8,9,2]; returnList = list
        case 2: let list = [1,3,9,10]; returnList = list
        case 3: let list = [2,4,10,11]; returnList = list
        case 4: let list = [3,5,11,12]; returnList = list
        case 5: let list = [4,6,12,13]; returnList = list
        case 6: let list = [5,13,14]; returnList = list
        case 7: let list = [0,8,15]; returnList = list
        case 8: let list = [0,1,2,7,9,15,16]; returnList = list
        case 9: let list = [1,2,3,8,10,16,17]; returnList = list
        case 10: let list = [2,3,4,9,11,17,18]; returnList = list
        case 11: let list = [3,4,5,10,12,18,19]; returnList = list
        case 12: let list = [4,5,6,11,13,19,20]; returnList = list
        case 13: let list = [5,6,7,12,14,20,21]; returnList = list
        case 14: let list = [6,13,21]; returnList = list
        case 15: let list = [7,8,16,22,23]; returnList = list
        case 16: let list = [8,9,15,17,23,24]; returnList = list
        case 17: let list = [9,10,16,18,24,25]; returnList = list
        case 18: let list = [10,11,17,19,25,26]; returnList = list
        case 19: let list = [11,12,18,20,26,27]; returnList = list
        case 20: let list = [12,13,19,21,27,28]; returnList = list
        case 21: let list = [13,14,20,28,29]; returnList = list
        case 22: let list = [15,23,30]; returnList = list
        case 23: let list = [15,16,22,24,30,31]; returnList = list
        case 24: let list = [16,17,23,25,31,32]; returnList = list
        case 25: let list = [17,18,24,26,32,33]; returnList = list
        case 26: let list = [18,19,25,27,33,34]; returnList = list
        case 27: let list = [19,20,26,28,34,35]; returnList = list
        case 28: let list = [20,21,27,29,35,36]; returnList = list
        case 29: let list = [21,28,26]; returnList = list
        case 30: let list = [22,23,31,37,38]; returnList = list
        case 31: let list = [23,24,30,32,38,39]; returnList = list
        case 32: let list = [24,25,31,33,39,40]; returnList = list
        case 33: let list = [25,26,32,34,40,41]; returnList = list
        case 34: let list = [26,27,33,35,41,42]; returnList = list
        case 35: let list = [27,28,34,36,42,43]; returnList = list
        case 36: let list = [28,29,35,43,44]; returnList = list
        case 37: let list = [30,38,45]; returnList = list
        case 38: let list = [30,31,37,39,45,46]; returnList = list
        case 39: let list = [31,32,38,40,46,47]; returnList = list
        case 40: let list = [32,33,39,41,47,48]; returnList = list
        case 41: let list = [33,34,40,42,48,49]; returnList = list
        case 42: let list = [34,35,41,43,49,50]; returnList = list
        case 43: let list = [35,36,42,44,50,51]; returnList = list
        case 44: let list = [36,43,51]; returnList = list
        case 45: let list = [37,38,46,52,53]; returnList = list
        case 46: let list = [38,39,45,47,53,54]; returnList = list
        case 47: let list = [39,40,46,48,54,55]; returnList = list
        case 48: let list = [40,41,47,49,55,56]; returnList = list
        case 49: let list = [41,42,48,50,56,57]; returnList = list
        case 50: let list = [42,43,49,51,57,58]; returnList = list
        case 51: let list = [43,44,50,58,59]; returnList = list
        case 52: let list = [45,53,60]; returnList = list
        case 53: let list = [45,46,52,54,60,61]; returnList = list
        case 54: let list = [46,47,53,55,61,62]; returnList = list
        case 55: let list = [47,48,54,56,62,63]; returnList = list
        case 56: let list = [48,49,55,57,63,64]; returnList = list
        case 57: let list = [49,50,56,58,64,65]; returnList = list
        case 58: let list = [50,51,57,59,65,66]; returnList = list
        case 59: let list = [51,58,66]; returnList = list
        case 60: let list = [52,53,61]; returnList = list
        case 61: let list = [53,54,60,62]; returnList = list
        case 62: let list = [54,55,61,63]; returnList = list
        case 63: let list = [55,56,62,64]; returnList = list
        case 64: let list = [56,57,63,65]; returnList = list
        case 65: let list = [57,58,64,66]; returnList = list
        case 66: let list = [58,59,65]; returnList = list
        default: let list = [0]; returnList = list
        }

        return returnList
    }
    
//    func thirdSelectableIndexWithTwoSelected(second: Int) -> [Int?] {
//    
//        switch second {
//        case 0: let list: [Int?] = []
//        case 1: let list = [0,2]
//        case 2: let list = [1,3]
//        case 3: let list = [2,4]
//        case 4: let list = [3,5]
//        case 5: let list = [4,6]
//        case 6: let list = [nil]
//        case 7: let list = [nil]
//        case 8: let list = [0,1,2,7,9,15,16]
//        case 9: let list = [1,2,3,8,10,16,17]
//        case 10: let list = [2,3,4,9,11,17,18]
//        case 11: let list = [3,4,5,10,12,18,19]
//        case 12: let list = [4,5,6,11,13,19,20]
//        case 13: let list = [5,6,7,12,14,20,21]
//        case 14: let list = [nil]
//        case 15: let list = [7,8,22,23]
//        case 16: let list = [8,9,15,17,23,24]
//        case 17: let list = [9,10,16,18,24,25]
//        case 18: let list = [10,11,17,19,25,26]
//        case 19: let list = [11,12,18,20,26,27]
//        case 20: let list = [12,13,19,21,27,28]
//        case 21: let list = [13,14,28,29]
//        case 22: let list = [nil]
//        case 23: let list = [15,16,22,24,30,31]
//        case 24: let list = [16,17,23,25,31,32]
//        case 25: let list = [17,18,24,26,32,33]
//        case 26: let list = [18,19,25,27,33,34]
//        case 27: let list = [19,20,26,28,34,35]
//        case 28: let list = [20,21,27,29,35,36]
//        case 29: let list = [nil]
//        case 30: let list = [22,23,37,38]
//        case 31: let list = [23,24,30,32,38,39]
//        case 32: let list = [24,25,31,33,39,40]
//        case 33: let list = [25,26,32,34,40,41]
//        case 34: let list = [26,27,33,35,41,42]
//        case 35: let list = [27,28,34,36,42,43]
//        case 36: let list = [28,29,43,44]
//        case 37: let list = [nil]
//        case 38: let list = [30,31,37,39,45,46]
//        case 39: let list = [31,32,38,40,46,47]
//        case 40: let list = [32,33,39,41,47,48]
//        case 41: let list = [33,34,40,42,48,49]
//        case 42: let list = [34,35,41,43,49,50]
//        case 43: let list = [35,36,42,44,50,51]
//        case 44: let list = [nil]
//        case 45: let list = [37,38,52,53]
//        case 46: let list = [38,39,45,47,53,54]
//        case 47: let list = [39,40,46,48,54,55]
//        case 48: let list = [40,41,47,49,55,56]
//        case 49: let list = [41,42,48,50,56,57]
//        case 50: let list = [42,43,49,51,57,58]
//        case 51: let list = [43,44,58,59]
//        case 52: let list = [nil]
//        case 53: let list = [45,46,52,54,60,61]
//        case 54: let list = [46,47,53,55,61,62]
//        case 55: let list = [47,48,54,56,62,63]
//        case 56: let list = [48,49,55,57,63,64]
//        case 57: let list = [49,50,56,58,64,65]
//        case 58: let list = [50,51,57,59,65,66]
//        case 59: let list = [nil]
//        case 60: let list = [nil]
//        case 61: let list = [60,62]
//        case 62: let list = [61,63]
//        case 63: let list = [62,64]
//        case 64: let list = [63,65]
//        case 65: let list = [64,66]
//        case 66: let list = [nil]
//        default: break
//        }
//        return list
//        
//    }
//    
//    func forthSelectableIndexWithThreeSelected(third: Int) -> [Int?] {
//        
//        switch third {
//        case 0: let list = [nil]
//        case 1: let list = [0]
//        case 2: let list = [1,3]
//        case 3: let list = [2,4]
//        case 4: let list = [3,5]
//        case 5: let list = [6]
//        case 6: let list = [nil]
//        case 7: let list = [nil]
//        case 8: let list = [0,1,2,7]
//        case 9: let list = [1,2,3,8,10]
//        case 10: let list = [2,3,4,9,11]
//        case 11: let list = [3,4,5,10,12]
//        case 12: let list = [4,5,6,11,13]
//        case 13: let list = [5,6,7,14]
//        case 14: let list = [nil]
//        case 15: let list = [7,22]
//        case 16: let list = [8,9,15,23,24]
//        case 17: let list = [9,10,16,18,24,25]
//        case 18: let list = [10,11,17,19,25,26]
//        case 19: let list = [11,12,18,20,26,27]
//        case 20: let list = [12,13,21,27,28]
//        case 21: let list = [14,29]
//        case 22: let list = [nil]
//        case 23: let list = [15,16,22,30,31]
//        case 24: let list = [16,17,23,25,31,32]
//        case 25: let list = [17,18,24,26,32,33]
//        case 26: let list = [18,19,25,27,33,34]
//        case 27: let list = [19,20,26,28,34,35]
//        case 28: let list = [20,21,29,35,36]
//        case 29: let list = [nil]
//        case 30: let list = [22,37]
//        case 31: let list = [23,24,30,38,39]
//        case 32: let list = [24,25,31,33,39,40]
//        case 33: let list = [25,26,32,34,40,41]
//        case 34: let list = [26,27,33,35,41,42]
//        case 35: let list = [27,28,36,42,43]
//        case 36: let list = [29,44]
//        case 37: let list = [nil]
//        case 38: let list = [30,31,37,45,46]
//        case 39: let list = [31,32,38,40,46,47]
//        case 40: let list = [32,33,39,41,47,48]
//        case 41: let list = [33,34,40,42,48,49]
//        case 42: let list = [34,35,41,43,49,50]
//        case 43: let list = [35,36,44,50,51]
//        case 44: let list = [nil]
//        case 45: let list = [37,52]
//        case 46: let list = [38,39,45,53,54]
//        case 47: let list = [39,40,46,48,54,55]
//        case 48: let list = [40,41,47,49,55,56]
//        case 49: let list = [41,42,48,50,56,57]
//        case 50: let list = [42,43,51,57,58]
//        case 51: let list = [44,59]
//        case 52: let list = [nil]
//        case 53: let list = [52,60,61]
//        case 54: let list = [53,55,61,62]
//        case 55: let list = [54,56,62,63]
//        case 56: let list = [55,57,63,64]
//        case 57: let list = [56,58,64,65]
//        case 58: let list = [59,65,66]
//        case 59: let list = [nil]
//        case 60: let list = [nil]
//        case 61: let list = [60]
//        case 62: let list = [61,63]
//        case 63: let list = [62,64]
//        case 64: let list = [63,65]
//        case 65: let list = [66]
//        case 66: let list = [nil]
//        default: break
//        }
//        return list
//        
//    }
//    
//    func fifthSelectableIndexWithFourSelected(forth: Int) -> [Int?] {
//        
//        switch third {
//        case 0: let list = [nil]
//        case 1: let list = [0]
//        case 2: let list = [1]
//        case 3: let list = [2,4]
//        case 4: let list = [5]
//        case 5: let list = [6]
//        case 6: let list = [nil]
//        case 7: let list = [nil]
//        case 8: let list = [0,2,7]
//        case 9: let list = [1,2,3,8]
//        case 10: let list = [2,3,4,9,11]
//        case 11: let list = [3,4,5,10,12]
//        case 12: let list = [4,5,6,13]
//        case 13: let list = [6,7,14]
//        case 14: let list = [nil]
//        case 15: let list = [7,22]
//        case 16: let list = [8,9,15]
//        case 17: let list = [9,10,16,18]
//        case 18: let list = [10,11,17,19]
//        case 19: let list = [11,12,18,20]
//        case 20: let list = [12,13,21]
//        case 21: let list = [14]
//        case 22: let list = [nil]
//        case 23: let list = [15,22,30]
//        case 24: let list = [16,17,23,31,32]
//        case 25: let list = [17,18,24,26,32,33]
//        case 26: let list = [18,19,25,27,33,34]
//        case 27: let list = [19,20,28,34,35]
//        case 28: let list = [21,29,36]
//        case 29: let list = [nil]
//        case 30: let list = [22,37]
//        case 31: let list = [23,24,30,38,39]
//        case 32: let list = [24,25,31,39,40]
//        case 33: let list = [25,26,32,34,40,41]
//        case 34: let list = [26,27,35,41,42]
//        case 35: let list = [27,28,36,42,43]
//        case 36: let list = [29,44]
//        case 37: let list = [nil]
//        case 38: let list = [30,37,45]
//        case 39: let list = [31,32,38,46,47]
//        case 40: let list = [32,33,39,41,47,48]
//        case 41: let list = [33,34,40,42,48,49]
//        case 42: let list = [34,35,43,49,50]
//        case 43: let list = [36,44,51]
//        case 44: let list = [nil]
//        case 45: let list = [52]
//        case 46: let list = [45,53,54]
//        case 47: let list = [46,54,55]
//        case 48: let list = [47,49,55,56]
//        case 49: let list = [50,56,57]
//        case 50: let list = [51,57,58]
//        case 51: let list = [59]
//        case 52: let list = [nil]
//        case 53: let list = [52,60,61]
//        case 54: let list = [53,61,62]
//        case 55: let list = [54,56,62,63]
//        case 56: let list = [55,57,63,64]
//        case 57: let list = [58,64,65]
//        case 58: let list = [59,66]
//        case 59: let list = [nil]
//        case 60: let list = [nil]
//        case 61: let list = [60]
//        case 62: let list = [61]
//        case 63: let list = [62,64]
//        case 64: let list = [65]
//        case 65: let list = [66]
//        case 66: let list = [nil]
//        default: break
//        }
//        return list
//        
//    }
    
    
    
}
