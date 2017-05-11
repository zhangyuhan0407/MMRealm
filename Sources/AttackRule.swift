//
//  AttackRule.swift
//  AAA
//
//  Created by yuhan zhang on 10/25/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


enum AttackRule: CustomStringConvertible {
    
    case melee
    case range
    case help
    case reverse
    case current
    case mostSP
    case fewerSP
    case mostHP
    case fewerHP
    case random
    case fewerHPHelp
    case next
    case threeRandom
    
    
    static func find(position: Int, rule: AttackRule) -> [Int] {
        switch rule {
        case .melee:
            switch position {
            case 0,4,8,12:
                return [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            case 1,5,9,13:
                return [1,0,2,3,5,4,6,7,9,8,10,11,13,12,14,15]
            case 2,6,10,14:
                return [2,1,3,0,6,5,7,4,10,9,11,8,14,13,15,12]
            case 3,7,11,15:
                return [3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
            default:
                return [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            }
        case .range:
            switch position {
            case 0,4,8,12:
                return [0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15]
            case 1,5,9,13:
                return [1,5,9,13,0,4,8,12,2,6,10,14,3,7,11,15]
            case 2,6,10,14:
                return [2,6,10,14,1,5,9,13,3,7,11,15,0,4,8,12]
            case 3,7,11,15:
                return [3,7,11,15,2,6,10,14,1,5,9,13,0,4,8,12]
            default:
                return []
            }
        case .current:
            return [position]
        case .reverse:
            return [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        default:
            return [position]
        }
    }
    
    
    static func deserilize(fromString s: String) -> AttackRule {
        switch s {
            case "melee":
            return .melee
            case "range":
            return .range
            case "help":
            return .help
        default:
            return .melee
        }
    }
    
    
 
    
    var description: String {
        switch self {
        case .melee:
            return "melee"
        case .range:
            return "range"
        case .help:
            return "help"
        case .reverse:
            return "reverse"
        case .current:
            return "current"
        case .mostSP:
            return "mostsp"
        case .fewerSP:
            return "fewersp"
        case .mostHP:
            return "mosthp"
        case .fewerHP:
            return "fewerhp"
        case .random:
            return "random"
        case .fewerHPHelp:
            return "fewerhphelp"
        case .next:
            return "next"
        case .threeRandom:
            return "threerandom"
        }
    }
    
}








