//
//  MMUser.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import OCTJSON
import OCTFoundation


#if os(Linux)
    let BasePath =              "/root/Developer/MMRealm"
    let UserCharRepoPath =      "/root/Developer/MMRealm/UserCharRepo"
    let UserRepoPath =          "/root/Developer/MMRealm/UserRepo"
    let UserFabaoRepoPath =     "/root/Developer/MMRealm/UserFabaoRepo"
    let UserBagRepoPath =       "/root/Developer/MMRealm/UserBagRepo"
#else
    let BasePath =              "/Users/yorg/Developer/MMRealm"
    let UserCharRepoPath =      "/Users/yorg/Developer/MMRealm/UserCharRepo"
    let UserRepoPath =          "/Users/yorg/Developer/MMRealm/UserRepo"
    let UserFabaoRepoPath =     "/Users/yorg/Developer/MMRealm/UserFabaoRepo"
    let UserBagRepoPath =       "/Users/yorg/Developer/MMRealm/UserBagRepo"
#endif


class MMUser: OCTModel {
    
    
    var key: String
    
    var vipLevel: Int = 0
    var level: Int = 0
    var pveLevel: Int = 0
    var pvpLevel: Int = 0
    
    var yuanbao: Int = 0
    var gold: Int = 0
    
    
    var lastLogin: Date
    var token: String = ""
    
    
    var bag: [String: Int] = [:]
    var fabao: [MMFabao] = []
    var chars: [MMCharacter] = []
    
    
    required init(fromDictionary dict: [String : Any]) {
        self.key = dict[kKey] as! String
        self.lastLogin = Date()
        self.vipLevel = dict[kVIPLevel] as? Int ?? 0
        self.level = dict[kLevel] as? Int ?? 0
        self.pveLevel = dict[kPVELevel] as? Int ?? 0
        self.pvpLevel = dict[kPVPLevel] as? Int ?? 0
        self.yuanbao = dict[kYuanBao] as? Int ?? 0
        self.gold = dict[kGold] as? Int ?? 0
    }
    
    
    
    
    func toDictionary() -> [String : Any] {
        return [kKey: self.key,
                kLastLogin: self.lastLogin.description,
                kVIPLevel: self.vipLevel,
                kLevel: self.level,
                kPVELevel: self.pveLevel,
                kPVPLevel: self.pvpLevel,
                kYuanBao: self.yuanbao,
                kGold: self.gold]
    }
    
    
    var charsJSON: JSON {
        var jsons = [JSON]()
        for c in chars {
            jsons.append(c.json)
        }
        return JSON(jsons)
    }
    
    
    var fabaoJSON: JSON {
        var jsons = [JSON]()
        for fb in fabao {
            jsons.append(fb.json)
        }
        return JSON(jsons)
    }
    
    
    var bagJSON: JSON {
        return JSON(self.bag)
    }
    
    
    
    var json: JSON {
        var json = JSON(self.toDictionary())

        json["bag"] = self.bagJSON
        json["chars"] = self.charsJSON
        json["fabao"] = self.fabaoJSON
        
        return json
    }
    
}











