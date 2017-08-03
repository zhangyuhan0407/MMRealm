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
    
    
    static func deserialize(fromJSONArray jsons: JSON) -> [Self] {
        if let array = jsons.array {
            return array.map { deserialize(fromJSON: $0) }
        }
        return []
    }
    
    static func arrayToJSON(array: [Self]) -> JSON {
        return JSON(array.map { $0.json })
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
        
        let json = JSON.read(fromFile: "\(INVPath)/\(key)")!
        
        return MMInventoryRepo.deserialize(fromJSON: json)
        
    }
    
    
    
    
//    static func convert(withKey key: String) -> MMInventory {
//        let json: JSON
//        let realKey: String
//        let count: Int
//        if key.contains("PROP_Gold") {
//            count = Int(key.components(separatedBy: "_").last!)!
//            realKey = key.components(separatedBy: "_").dropLast().joined(separator: "_")
//        }
//        else if key.contains("PROP_Gold") {
//            count = Int(key.components(separatedBy: "_").last!)!
//            realKey = key.components(separatedBy: "_").dropLast().joined(separator: "_")
//        }
//        else if key.contains("INV_Misc") {
//            count = Int(key.components(separatedBy: "_").last!)!
//            realKey = key.components(separatedBy: "_").dropLast().joined(separator: "_")
//        }
//        else {
//            count = 1
//            realKey = key
//
//        }
//
//        json = JSON.read(fromFile: "\(INVPath)/\(realKey)")!
//        
//        var inv = MMInventoryRepo.deserialize(fromJSON: json)
//        inv.count = count
//        
//        return inv
//    }
//    
//    
//    
//    
//    static func convert(withKeys keys: [String]) -> [MMInventory] {
//        return keys.map {
//            convert(withKey: $0)
//        }
//    }
    
    
    static func toKey(inv: MMInventory) -> String {
        switch inv.category {
        case .misc:
            let key = "\(inv.key)_\(inv.count)"
            return key
        default:
            return inv.key
        }
    }
    
    
    static func toKeys(invs: [MMInventory]) -> [String] {
        return invs.map {
            toKey(inv: $0)
        }
    }
    
    
    static func toDictionary(json: JSON) -> [String: Any] {
        
        
        let gold = json[kGold].int ?? 0
        let silver = json[kSilver].int ?? 0
        
        
        var weapons = [MMWeapon]()
        for j in json[kWeapons].array ?? [] {
            weapons.append(MMWeapon.deserialize(fromJSON: j))
        }
        
        var armors = [MMArmor]()
        for j in json[kArmors].array ?? [] {
            armors.append(MMArmor.deserialize(fromJSON: j))
        }
        
        var trinkets = [MMTrinket]()
        for j in json[kTrinkets].array ?? [] {
            trinkets.append(MMTrinket.deserialize(fromJSON: j))
        }
        
        var miscs = [MMMisc]()
        for j in json[kMiscs].array ?? [] {
            miscs.append(MMMisc.deserialize(fromJSON: j))
        }
        
        
        
        var ret = [String: Any]()
        ret.updateValue(gold, forKey: "gold")
        ret.updateValue(silver, forKey: kSilver)
        ret.updateValue(weapons, forKey: "weapons")
        ret.updateValue(armors, forKey: "armors")
        ret.updateValue(trinkets, forKey: "trinkets")
        ret.updateValue(miscs, forKey: "miscs")
        
        return ret
    }
    
    
    
    static func deserialize(fromJSON json: JSON) -> MMInventory {
        let type = MMCategory.deserialize(fromString: json["category"].string!)
        
        switch type {
        case .weapon:
            return MMWeapon.deserialize(fromJSON: json)
        case .armor:
            return MMArmor.deserialize(fromJSON: json)
        case .trinket:
            return MMTrinket.deserialize(fromJSON: json)
        case .misc:
            return MMMisc.deserialize(fromJSON: json)
        }
    }
    
    
    
    
    
    
}

























