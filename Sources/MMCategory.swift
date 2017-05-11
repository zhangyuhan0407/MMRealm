//
//  MMCategory.swift
//  MMClient
//
//  Created by yuhan zhang on 4/30/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation


enum MMCategory: CustomStringConvertible {
    
    case weapon
    case armor
    case trinket
    case misc
    
    
    var description: String {
        switch self {
        case .weapon:
            return "weapon"
        case .armor:
            return "armor"
        case .trinket:
            return "trinket"
        case .misc:
            return "misc"
        }
    }
    
    
    static func deserialize(fromString s: String) -> MMCategory {
        switch s.lowercased() {
        case "weapon":
            return .weapon
        case "armor":
            return .armor
        case "trinket":
            return .trinket
        case "misc":
            return .misc
        default:
            fatalError()
        }
    }
    
}


enum MMRarity: CustomStringConvertible {
    case white
    case green
    case blue
    case purple
    case orange
    
    
    var description: String {
        switch self {
        case .green:
            return "green"
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .purple:
            return "purple"
        default:
            return "white"
        }
    }
    
    
    static func deserialize(fromString s: String) -> MMRarity {
        switch s.lowercased() {
        case "green":
            return .green
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "white":
            return .white
        default:
            fatalError()
        }
    }
    
}





