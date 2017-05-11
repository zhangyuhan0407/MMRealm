//
//  MMInventory.swift
//  MMClient
//
//  Created by yuhan zhang on 4/13/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol JSONDeserializable: CustomStringConvertible {
    static func deserialize(fromJSON json: JSON) -> Self
    var json: JSON { get }
    var dict: [String: Any] { get }
}


extension JSONDeserializable {
    var description: String {
        return json.description
    }
    
    var json: JSON {
        return JSON(dict)
    }
}


protocol MMInventory: JSONDeserializable {
    
    var key: String { get set }
    var imageName: String { get set }
    var category: MMCategory { get set }
    var rarity: MMRarity { get set }
    
    var count: Int { get set }
    
}



class MMInventoryRepo {
    
    
    static func create(withKey key: String) -> MMInventory {
        
        let array = key.components(separatedBy: "_")
        let category = MMCategory.deserialize(fromString: array[1])
        let level = Int(array[2])!
        
        
        
        let randomNumber = Int.random()
        var rarity: MMRarity = .white
        if randomNumber < 10 {
            rarity = .purple
        } else if randomNumber < 30 {
            rarity = .blue
        } else if randomNumber < 60 {
            rarity = .green
        }
        
        
        switch category {
        case .weapon:
            var weapon = MMWeapon()
            weapon.key = NSUUID().description
            weapon.imageName = "\(array[0])_\(array[1])_\(category)_\(level)"
            weapon.rarity = rarity
            weapon.type = MMWeaponType.random()
            return weapon
        case .armor:
            var armor = MMArmor()
            armor.key = NSUUID().description
            armor.imageName = "\(array[0])_\(array[1])_\(category)_\(level)"
            armor.rarity = rarity
            armor.type = MMArmorType.random()
            return armor
        default:
            fatalError()
        }
        
        
        
    }
    
//    func create(key: String, category: String, rarity: String?) -> MMWeapon {
//
//        let cate = MMCategory.deserialize(fromString: category)
//
//        let rar: MMRarity
//        if let r = rarity {
//            rar = MMRarity.deserialize(fromString: r)
//        } else {
//            rar = MMRarity.white
//        }
//
//
//        let ret = MMWeapon()
//
//        
//        
//        return ret
//    }
    
}



extension Int {
    public static func random(max: Int = 100) -> Int {
        #if os(Linux)
            return Int(Glibc.random() % max)
        #else
            return Int(arc4random() % UInt32(max))
        #endif
    }
}





















