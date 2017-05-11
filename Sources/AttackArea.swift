//
//  AttackArea.swift
//  AAA
//
//  Created by yuhan zhang on 10/25/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


enum AttackArea: CustomStringConvertible {
    case single
    case row
    case column
    case nineCube
    case cross
    case wings
    case all
    case singleTriple
    case singleTwice
    
    static var rowNumber: Int {
        return 4
    }
    static var columnNumber: Int {
        return 4
    }
    
    private static func position(ofCell cell: Int) -> (Int, Int) {
        return (cell/columnNumber + 1, cell%columnNumber + 1)
    }
    
    
    static func findrow(forCell cell: Int) -> [Int] {
        if cell > rowNumber * columnNumber {
            return []
        }
        
        let (row, _) = position(ofCell: cell)
        
        var ret = [Int]()
        for i in 0..<columnNumber {
            ret.append((row - 1) * columnNumber + i)
        }
        
        return ret
    }
    
    
    static func findcolumn(forCell cell: Int) -> [Int] {
        if cell > rowNumber * columnNumber {
            return []
        }
        
        let (_, column) = position(ofCell: cell)
        
        var ret = [Int]()
        for i in 0..<rowNumber {
            ret.append((column % rowNumber) + rowNumber * i)
        }
        
        return ret
    }
    
    
    
    static func findCross(forCell cell: Int) -> [Int] {
        var ret = [Int]()
        ret.append(cell - 1)
        ret.append(cell + 1)
        ret.append(cell)
        ret.append(cell - rowNumber)
        ret.append(cell + rowNumber)
        return ret.filter { $0 >= 0 && $0 < columnNumber * rowNumber}
    }
    
    
    static func findWings(forCell cell: Int) -> [Int] {
        var ret = [Int]()
        switch cell {
        case 0, 4, 8, 12:
            ret = [cell + 5]
        case 3, 7, 11, 15:
            ret = [cell + 3]
        default:
            ret =  [cell + 3, cell + 5]
        }
        return ret.filter { $0 >= 0 && $0 < columnNumber * rowNumber}
    }
    
    
    static func findall() -> [Int] {
        var ret = [Int]()
        for i in 0..<rowNumber*columnNumber {
            ret.append(i)
        }
        return ret
    }
    
    
    static func findnineCube(forCell cell: Int) -> [Int] {
        switch cell {
        case 0:
            return [0,1,4,5]
        case 1:
            return [0,1,2,4,5,6]
        case 2:
            return [1,2,3,5,6,7]
        case 3:
            return [2,3,6,7]
        case 4:
            return [0,1,4,5,8,9]
        case 7:
            return [2,3,6,7,10,11]
        case 8:
            return [4,5,8,9,12,13]
        case 11:
            return [6,7,10,11,14,15]
        case 12:
            return [8,9,12,13]
        case 15:
            return [10,11,14,15]
        default:
            var ret = [Int]()
            ret.append(cell - 1)
            ret.append(cell + 1)
            ret.append(cell)
            ret.append(cell - rowNumber)
            ret.append(cell - rowNumber - 1)
            ret.append(cell - rowNumber + 1)
            ret.append(cell + rowNumber)
            ret.append(cell + rowNumber - 1)
            ret.append(cell + rowNumber + 1)
            return ret.filter { $0 >= 0 && $0 < columnNumber * rowNumber}
        }
        
    }
    
    
    
    static func find(position: Int, area: AttackArea) -> [Int] {
        switch area {
        case .single:
            return [position]
        case .row:
            return AttackArea.findrow(forCell: position)
        case .column:
            return AttackArea.findcolumn(forCell: position)
        case .nineCube:
            return AttackArea.findnineCube(forCell: position)
        case .cross:
            return AttackArea.findCross(forCell: position)
        case .wings:
            return AttackArea.findWings(forCell: position)
        case .all:
            return AttackArea.findall()
        case .singleTriple:
            return [position, position, position]
        case .singleTwice:
            return [position, position]
        }
    }
 
    
    
    static func deserilize(fromString s: String) -> AttackArea {
        return .single
    }
    
    
    var description: String {
        switch self {
        case .all:
            return "all"
        case .column:
            return "column"
        case .nineCube:
            return "ninecube"
        case .row:
            return "row"
        case .cross:
            return "cross"
        case .wings:
            return "wings"
        case .single:
            return "single"
        case .singleTriple:
            return "singletriple"
        case .singleTwice:
            return "singletwice"
        }
    }
    
    
    
    
    
}
