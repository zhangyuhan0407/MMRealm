//
//  MMTrinket.swift
//  MMClient
//
//  Created by yuhan zhang on 5/3/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


struct MMTrinket: MMInventory {
    
    var key: String
    var imageName: String
    var displayName: String = "DEFAULT_DISPLAYE_NAME"
    var category: MMCategory = .trinket
    var rarity: MMRarity = .white
    var count: Int = 0
    
    
    var hp = 0
    
    
    var atk: Int = 0
    var def: Int = 0
    var mag: Int = 0
    
    
    var baoji: Int = 0
    var shanbi: Int = 0
    var mingzhong: Int = 0
    var gedang: Int = 0
    
    var zaisheng = 0
    var xixue = 0
    var fantanwuli = 0
    var fantanfashu = 0
    
    
    
    init() {
        self.key = ""
        self.imageName = ""
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMTrinket {
        
        var ret = MMTrinket()
        
        ret.key = json[kKey].string!
        ret.imageName = json[kImageName].stringValue
        ret.displayName = json[kDisplayeName].stringValue
        ret.rarity = MMRarity.deserialize(fromString: json[kRarity].stringValue)
        ret.count = json[kCount].intValue
        
        
        ret.atk = json[kATK].int ?? 0
        ret.mag = json[kMAG].int ?? 0
        ret.baoji = json[kBaoJi].int ?? 0
        ret.mingzhong = json[kMingZhong].int ?? 0
        ret.xixue = json[kXiXue].int ?? 0
        
        
        ret.hp = json[kHP].int ?? 0
        ret.def = json[kDEF].int ?? 0
        ret.shanbi = json[kShanBi].int ?? 0
        ret.gedang = json[kGeDang].int ?? 0
        ret.zaisheng = json[kZaiSheng].int ?? 0
        
        
        return ret
    }
    
    
    var dict: [String : Any] {
        return [kKey: self.key,
                kImageName: imageName,
                kDisplayeName: displayName,
                kCategory: category.description,
                kRarity: rarity.description,
                kCount: count,
                kATK: atk,
                kMAG:mag,
                kBaoJi: baoji,
                kMingZhong: mingzhong,
                kXiXue: xixue,
                kHP: hp,
                kDEF: def,
                kShanBi: shanbi,
                kGeDang: gedang,
                kZaiSheng: zaisheng
            ] as [String: Any]
    }
    
    
    static func random(level: Int) -> MMTrinket {
        var ret = MMTrinket()
        
        
        return ret
    }
    
    
}





