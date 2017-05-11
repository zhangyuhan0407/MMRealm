//
//  MMUser.swift
//  MMClient
//
//  Created by yuhan zhang on 4/4/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation



final class MMUser: JSONDeserializable {
    
    static var sharedInstance = MMUser()
    
    var messageQueue: [String: Any]!
    
    var key: String = "zyh"
    var gold = 0
    var yuanbao = 0
    
    
    var vipLevel: Int = 0
    var level: Int = 0
    var pveLevel: Int = 0
    var pvpLevel: Int = 0
    var lastLogin: Date = Date()
    var token: String = ""

    
    var weapons: [MMWeapon] = []
    
    var armors: [MMArmor] = []
    
    var trinkets: [MMTrinket] = []
    
    var miscs: [MMMisc] = []
    
    
    
    var characters = [MMCharacter]()
    
    
    
    private init() {

    }
    
    
    
    var synchronizeQueue: [String: Any] = [:]
    
    
    var dict: [String : Any] {
        return [kKey: self.key,
                kLastLogin: self.lastLogin.description,
                kVIPLevel: self.vipLevel,
                kLevel: self.level,
                kPVELevel: self.pveLevel,
                kPVPLevel: self.pvpLevel,
                kYuanBao: self.yuanbao,
                kGold: self.gold]
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMUser {
        let user = MMUser()
        user.key = json[kKey].stringValue
        user.lastLogin = Date()
        user.vipLevel = json[kVIPLevel].intValue
        user.level = json[kLevel].intValue
        user.pveLevel = json[kPVELevel].intValue
        user.pvpLevel = json[kPVPLevel].intValue
        user.yuanbao = json[kYuanBao].intValue
        user.gold = json[kGold].intValue
        return user
    }
    
}












