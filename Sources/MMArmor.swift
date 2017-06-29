//
//  MMArmor.swift
//  MMClient
//
//  Created by yuhan zhang on 5/3/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


enum MMArmorType: String {
    case Cloth
    case Leather
    case Chain
    case Plate
    
    static func deserialize(from s: String) -> MMArmorType {
        return MMArmorType(rawValue: s)!
    }
    
    
    static func random() -> MMArmorType {
        let index = Int.random()
        if index < 25 {
            return.Cloth
        } else if index < 50 {
            return .Leather
        } else if index < 75 {
            return .Chain
        } else {
            return .Plate
        }
        
    }
}


struct MMArmor: MMInventory {
    
    var key: String = "DEFAULT_ARMOR"
    var imageName: String = "DEFAULT_ARMOR"
    var displayName: String = "DEFAULT_DISPLAYE_NAME"
    var category: MMCategory = .armor
    var rarity: MMRarity = .white
    var count: Int = 0
    
    var type = MMArmorType.Cloth
    
    
    var hp: Int = 0
    var sp: Int = 0
    var atk: Int = 0
    var def: Int = 0
    
    
    var baoji: Int = 0
    var mingzhong: Int = 0
    var shanbi: Int = 0
    var gedang: Int = 0
    
    
    
    init() {
        
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMArmor {
        
        var ret = MMArmor()
        ret.key = json[kKey].stringValue
        ret.imageName = json[kImageName].stringValue
        ret.displayName = json[kDisplayeName].stringValue
        ret.rarity = MMRarity.deserialize(fromString: json[kRarity].stringValue)
        ret.type = MMArmorType.deserialize(from: json[kType].stringValue)
        
        
        ret.hp = json[kHP].int ?? 0
        ret.sp = json[kSP].int ?? 0
        ret.atk = json[kATK].int ?? 0
        ret.def = json[kDef].int ?? 0
        ret.baoji = json[kBaoJi].int ?? 0
        ret.mingzhong = json[kMingZhong].int ?? 0
        ret.gedang = json[kGeDang].int ?? 0
        ret.shanbi = json[kShanBi].int ?? 0
        
        return ret
    }
    
    
    var dict: [String : Any] {
        return [kKey: self.key,
                kImageName: imageName,
                kDisplayeName: displayName,
                kCategory: category.description,
                kRarity: rarity.description,
                kCount: count,
                kType: self.type.rawValue,
                kHP: self.hp,
                kSP: self.sp,
                kATK: self.atk,
                kDef: self.def,
                kBaoJi: baoji,
                kMingZhong: mingzhong,
                kShanBi: self.shanbi,
                kGeDang: self.gedang
            ] as [String: Any]
    }
    
    
    static func random(level: Int) -> MMArmor {
        var ret = MMArmor()
        ret.key = NSUUID().description
        
        
        let randomNumber = Int.random()
        var rarity: MMRarity = .white
        if randomNumber < 10 {
            rarity = .purple
        } else if randomNumber < 30 {
            rarity = .blue
        } else if randomNumber < 60 {
            rarity = .green
        }
        ret.rarity = rarity
        ret.type = MMArmorType.random()
        ret.imageName = "INV_Chest_\(ret.type.rawValue)_\(level)"
        
        
        let max = level * 40
        
        ret.hp = Int.random(max: max) + 1
        ret.def = Int.random(max: max) + 1
        
        ret.shanbi = Int.random(max: 30) + 1
        ret.gedang = Int.random(max: 30) + 1
        
        
        return ret
        
    }
    
}






