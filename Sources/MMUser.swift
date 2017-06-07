//
//  MMUser.swift
//  MMClient
//
//  Created by yuhan zhang on 4/4/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import OCTJSON


struct ShopItem: JSONDeserializable {
    var key: String
    var price: String
    var count: Int
    var position: Int = 0
    
    
    init(key: String, price: String, count: Int) {
        self.key = key
        self.price = price
        self.count = count
    }
    
    
    static func random() -> ShopItem {
        let r = Int.random(max: 10)
        
        switch r {
        case 0:
            return ShopItem(key: "INV_Misc_Metal_1", price: "PROP_Silver_50", count: 20)
        case 1:
            return ShopItem(key: "INV_Misc_Metal_2", price: "PROP_Silver_100", count: 10)
        case 2:
            return ShopItem(key: "INV_Misc_Metal_3", price: "PROP_Gold_20", count: 10)
        case 3:
            return ShopItem(key: "INV_Misc_Stone_1", price: "PROP_Silver_100", count: 20)
        case 4:
            return ShopItem(key: "INV_Misc_Stone_2", price: "PROP_Silver_200", count: 10)
        case 5:
            return ShopItem(key: "INV_Misc_Stone_3", price: "PROP_Gold_30", count: 10)
        case 6:
            return ShopItem(key: "INV_Weapon_Axe_1001", price: "PROP_Gold_500", count: 1)
        case 7:
            return ShopItem(key: "INV_Weapon_Axe_1001", price: "PROP_Gold_500", count: 1)
        case 8:
            return ShopItem(key: "INV_Weapon_Axe_1001", price: "PROP_Gold_500", count: 1)
        case 9:
            return ShopItem(key: "INV_Weapon_Axe_1001", price: "PROP_Gold_500", count: 1)
        default:
            fatalError()
        }
        
        
    }
    
    
    static func deserialize(fromJSON json: JSON) -> ShopItem {
        var ret = ShopItem(key: json[kKey].string!, price: json["price"].string!, count: json["count"].int ?? 1)
//        ret.key = json[kKey].string!
//        ret.price = json["price"].string!
//        ret.count = json["count"].int!
        ret.position = json["position"].int ?? 0
        return ret
    }
    
    var dict: [String : Any] {
        return [kKey: key,
                "price": price,
                "count": count,
                "position": position]
    }
    
    
}




final class MMUser: JSONDeserializable {
    
    static var sharedInstance = MMUser()
    
    var messageQueue: [String: Any]!
    
    var key: String = "zyh"
    var gold = 0
    var silver = 0
    
    
    var vipLevel: Int = 0
    var level: Int = 0
    
    
    var dungeonLevel: Int = 0
    
    
    var missionLevels: [Int] = []
    var shopItems: [ShopItem] = []
    
    
    
    var pveLevel: Int = 0
    var pvpLevel: Int = 0
    var lastLogin: Date = Date()
    var token: String = ""

    
    var weapons: [MMWeapon] = []
    
    var armors: [MMArmor] = []
    
    var trinkets: [MMTrinket] = []
    
    var miscs: [MMMisc] = []
    
    
    
    var characters = [MMCharacter]()
    
    
    
    init() { }
    
    
    
    var synchronizeQueue: [String: Any] = [:]
    
    
    var dict: [String : Any] {
        return [kKey: self.key,
                kLastLogin: self.lastLogin.description,
                kVIPLevel: self.vipLevel,
                kLevel: self.level,
                kDungeonLevel: self.dungeonLevel,
                "missionlevels": self.missionLevels,
                kPVELevel: self.pveLevel,
                kPVPLevel: self.pvpLevel,
                kSilver: self.silver,
                kGold: self.gold]
    }
    
    
   
    
    
    static func deserialize(fromJSON json: JSON) -> MMUser {
        let user = MMUser()
        user.key = json[kKey].stringValue
        user.lastLogin = Date()
        user.vipLevel = json[kVIPLevel].intValue
        user.dungeonLevel = json[kDungeonLevel].int ?? 0
        user.level = json[kLevel].intValue
        user.missionLevels = json["missionlevels"].intArray!
        
        user.pveLevel = json[kPVELevel].intValue
        user.pvpLevel = json[kPVPLevel].intValue
        user.silver = json[kSilver].intValue
        user.gold = json[kGold].intValue
        return user
    }
    
    
    
    
}












