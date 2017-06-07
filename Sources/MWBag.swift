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
            let silver = json[kSilver].int ?? 0
            
            
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
            ret.updateValue(silver, forKey: kSilver)
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












