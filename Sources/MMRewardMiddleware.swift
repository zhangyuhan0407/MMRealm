//
//  MMRewardMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import Kitura

import OCTJSON
import OCTFoundation


//class MMRewardMiddleware: RouterMiddleware {
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let key = request.parameters["key"] else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        guard let dict = request.jsonBody?.intDictionary else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        Logger.debug("URL: \(request.matchedPath), Body: \(dict)")
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        
//        
//        try user.updateBag(fromDictionary: dict)
//        
//        try response.send(OCTResponse.EmptyResult).end()
//    }
//    
//    
//}



class MMSlotsMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"]
//            let battleid = request.parameters["battleid"] as? Int
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let json = request.jsonBody,
                let properties = json["properties"].intDictionary,
                let invs = json["invs"].array
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        for k in properties.keys {
            if k == kGold {
                user.gold += properties[k]!
            } else if k == kYuanBao {
                user.yuanbao += properties[k]!
            }
        }
        
        
        for inv in invs {
            
            let category = MMCategory.deserialize(fromString: inv[kCategory].stringValue)
            
            switch category {
            case .weapon:
                user.add(weapon: MMWeapon.deserialize(fromJSON: inv))
            case .armor:
                user.add(armor: MMArmor.deserialize(fromJSON: inv))
            case .trinket:
                user.add(trinket: MMTrinket.deserialize(fromJSON: inv))
            case .misc:
                user.add(misc: MMMisc.deserialize(fromJSON: inv))
            }
            
            
//            user.add(inv: MMInventory.deserialize(fromJSON: inv))
        }
        
        
        try response.send(OCTResponse.Succeed(data: user.bagJSON)).end()
        
//        user.gold += json["gold"].int ?? 0
//        user.yuanbao += json["yuanbao"].int ?? 0
//
//        let weaponKeys = json["weaponkeys"].stringArray ?? []
//        var weapons = [MMWeapon]()
//        for key in weaponKeys {
//            let weapon = MMInventoryRepo.sharedInstance.create(key: key, category: "weapon", rarity: nil)
//            weapons.append(weapon)
//        }
//        
//        let armorKeys = json["armorkeys"].stringArray ?? []
//        var armors = [MMArmor]()
//        for key in armorKeys {
//            armors.append(MMInventoryRepo.sharedInstance.create(key: key, category: "armor", rarity: nil))
//        }
//        
//        
//        let trinketKeys = json["trinketkeys"].stringArray ?? []
//        var trinkets = [MMTrinket]()
//        for key in trinketKeys {
//            trinkets.append(MMInventoryRepo.sharedInstance.create(key: key, category: "trinkets", rarity: nil))
//        }
//        
//        
//        let miscKeys = json["misckeys"].stringArray ?? []
//        var miscs = [MMMisc]()
//        for key in miscKeys {
//            miscs.append(MMInventoryRepo.sharedInstance.create(key: key, category: "misc", rarity: nil))
//        }
//        
//        
//        var dict = [String: Any]()
//        dict.updateValue(user.gold, forKey: "gold")
//        dict.updateValue(user.yuanbao, forKey: "yuanbao")
//        dict.updateValue(weapons, forKey: "weapons")
//        dict.updateValue(armors, forKey: "armors")
//        dict.updateValue(trinkets, forKey: "trinkets")
//        dict.updateValue(miscs, forKey: "miscs")
//        
//        
//        do {
//            try user.updateBag(gain: dict, cost: [:])
//        } catch {
//            fatalError()
//        }
//        
//        
//        try response.send(OCTResponse.Succeed(data: user.bagJSON)).end()
        
    }
    
    
}




class MMBagMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"],
            let type = request.parameters["type"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(.ShouldLogin).end()
            return
        }
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        let array = json[type].array!
        switch type {
        case "weapon":
            var temp = [MMWeapon]()
            for j in array {
                temp.append(MMWeapon.deserialize(fromJSON: j))
            }
            user.weapons = temp
        case "armor":
            var temp = [MMArmor]()
            for j in array {
                temp.append(MMArmor.deserialize(fromJSON: j))
            }
            user.armors = temp
        case "trinket":
            var temp = [MMTrinket]()
            for j in array {
                temp.append(MMTrinket.deserialize(fromJSON: j))
            }
            user.trinkets = temp
        case "misc":
            var temp = [MMMisc]()
            for j in array {
                temp.append(MMMisc.deserialize(fromJSON: j))
            }
            user.miscs = temp
        default:
            fatalError()
        }
        
        
        
        MMUserDAO.sharedInstance.saveBag(forUser: user)
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
    
    
    
    
    
}



class MMUpdateBagMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(.ShouldLogin).end()
            return
        }
        
        guard let json = request.jsonBody
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        func toDictionary(json: JSON) -> [String: Any] {
            
            
            let gold = json[kGold].int ?? 0
            let yuanbao = json[kYuanBao].int ?? 0
            
            
            var weapons = [MMWeapon]()
            for j in json[kWeapons].array! {
                weapons.append(MMWeapon.deserialize(fromJSON: j))
            }
            
            var armors = [MMArmor]()
            for j in json[kArmors].array! {
                armors.append(MMArmor.deserialize(fromJSON: j))
            }
            
            var trinkets = [MMTrinket]()
            for j in json[kTrinkets].array! {
                trinkets.append(MMTrinket.deserialize(fromJSON: j))
            }
            
            var miscs = [MMMisc]()
            for j in json[kMiscs].array! {
                miscs.append(MMMisc.deserialize(fromJSON: j))
            }
            
            
            
            var ret = [String: Any]()
            ret.updateValue(gold, forKey: "gold")
            ret.updateValue(yuanbao, forKey: "yuanbao")
            ret.updateValue(weapons, forKey: "weapons")
            ret.updateValue(armors, forKey: "armors")
            ret.updateValue(trinkets, forKey: "trinkets")
            ret.updateValue(miscs, forKey: "miscs")
            
            return ret
        }
        
        let gain = toDictionary(json: json["gain"])
        let cost = toDictionary(json: json["cost"])
        
        do {
            try user.updateBag(gain: gain, cost: cost)
        } catch {
            fatalError()
        }
        
        try response.send(OCTResponse.EmptyResult).end()
    }
    
}












