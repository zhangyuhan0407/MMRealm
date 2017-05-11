////
////  MMUser.swift
////  MMRealm
////
////  Created by yuhan zhang on 11/29/16.
////
////
//
//import Foundation
//import OCTJSON
//import OCTFoundation
//
//
//class MMUser: OCTModel {
//    
//    
//    var key: String
//    
//    var vipLevel: Int = 0
//    var level: Int = 0
//    var pveLevel: Int = 0
//    var pvpLevel: Int = 0
//    
//    var yuanbao: Int = 0
//    var gold: Int = 0
//    
//    
//    var lastLogin: Date
//    var token: String = ""
//    
//    
////    var bag: [String: [MMInventory]] = [:]
//    
//    var weapon: [MMWeapon] = []
//    var armor: [MMArmor] = []
//    var trinket: [MMTrinket] = []
//    var misc: [MMMisc] = []
//    
//
//    var chars: [MMCharacter] = []
//    
//    
//    required init(fromDictionary dict: [String : Any]) {
//        self.key = dict[kKey] as! String
//        self.lastLogin = Date()
//        self.vipLevel = dict[kVIPLevel] as? Int ?? 0
//        self.level = dict[kLevel] as? Int ?? 0
//        self.pveLevel = dict[kPVELevel] as? Int ?? 0
//        self.pvpLevel = dict[kPVPLevel] as? Int ?? 0
//        self.yuanbao = dict[kYuanBao] as? Int ?? 0
//        self.gold = dict[kGold] as? Int ?? 0
//    }
//    
//    
//    
//    
//    func toDictionary() -> [String : Any] {
//        return [kKey: self.key,
//                kLastLogin: self.lastLogin.description,
//                kVIPLevel: self.vipLevel,
//                kLevel: self.level,
//                kPVELevel: self.pveLevel,
//                kPVPLevel: self.pvpLevel,
//                kYuanBao: self.yuanbao,
//                kGold: self.gold]
//    }
//    
//    
//    var infoJSON: JSON {
//        return JSON(toDictionary())
//    }
//    
//    
//    var charsJSON: JSON {
//        var jsons = [JSON]()
//        for c in chars {
//            jsons.append(c.json)
//        }
//        return JSON(jsons)
//    }
//    
//    
//    
//    var bagJSON: JSON {
//        
//        var json = JSON([String: Any]())
//        var tempJSON = [JSON]()
//        for weapon in self.weapon {
//            tempJSON.append(JSON(weapon.dict))
//        }
//        
//        json["weapon"] = JSON(tempJSON)
//        
//        
//        tempJSON = []
//        for armor in self.armor {
//            tempJSON.append(JSON(armor.dict))
//        }
//        
//        json["armor"] = JSON(tempJSON)
//        
//        
//        tempJSON = []
//        for trinket in self.trinket {
//            tempJSON.append(JSON(trinket.dict))
//        }
//        json["trinket"] = JSON(tempJSON)
//        
//        
//        tempJSON = []
//        for misc in self.misc {
//            tempJSON.append(JSON(misc.dict))
//        }
//        json["misc"] = JSON(tempJSON)
//        
//        json["gold"] = JSON(self.gold)
//        json["yuanbao"] = JSON(self.yuanbao)
//        
//        return json
//        
//    }
//    
//    
//    
//    var json: JSON {
//        var json = infoJSON
//
//        json["bag"] = self.bagJSON
//        json["chars"] = self.charsJSON
//
//        
//        return json
//    }
//    
//}
//
//
//
//
//
//
//
//
//
//
//
