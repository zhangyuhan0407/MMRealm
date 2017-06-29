//
//  MMUser.swift
//  MMClient
//
//  Created by yuhan zhang on 4/4/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import OCTJSON


final class MMUser: JSONDeserializable {
    
    static var sharedInstance = MMUser()
    
    var messageQueue: [String: Any]!
    
    var key: String = ""
    var displayTitle = "列兵"
    var displayName = "联盟战士"
    var gold = 0
    var silver = 0
    
    
    var vipLevel: Int = 0
    var level: Int = 0
    
    
    var hightestMissionCount = 0
    var gameState = 0
    var ticket = 0
    var dungeonLevel = 0
    var missionLevels: [Int] = []
    var shopItems: [ShopItem] = []
    var mails: [ENMail] = []
    
    var missionCompleteCount = 0
    
    var pvpLevel = 0
    
    var pveLevel: Int {
        return self.dungeonLevel/100
    }
    
    
    
    var armyMaxCount: Int {
        
        if self.dungeonLevel < 104 {
            return 2
        }
        else if self.dungeonLevel < 200 {
            return 3
        }
        else if self.dungeonLevel < 204 {
            return 4
        }
        else if self.dungeonLevel < 209 {
            return 5
        }
        else if self.dungeonLevel < 304 {
            return 6
        }
        else if self.dungeonLevel < 404 {
            return 7
        }
        else {
            return 8
        }
        
    }
    
    
    
    
    var charMaxCount: Int {
        return self.characters.count
    }
    
    
    
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
                "ticket": self.ticket,
                "gamestate": self.gameState,
                "missioncompletecount": self.missionCompleteCount,
                "displayname": self.displayName,
                "displaytitle": self.displayTitle,
                kPVPLevel: self.pvpLevel,
                kSilver: self.silver,
                kGold: self.gold]
    }
    
    
    
    
    static func deserialize(fromJSON json: JSON) -> MMUser {
        let user = MMUser()
        user.key = json[kKey].stringValue
        user.lastLogin = Date()
        user.vipLevel = json[kVIPLevel].intValue
        user.level = json[kLevel].intValue
        user.dungeonLevel = json[kDungeonLevel].intValue
        user.missionLevels = json["missionlevels"].intArray!
        user.ticket = json["ticket"].int ?? 0
        user.gameState = json["gamestate"].int ?? 0
        user.missionCompleteCount = json["missioncompletecount"].int ?? 0
        user.displayName = json["displayname"].string ?? "联盟战士"
        user.displayTitle = json["displaytitle"].string ?? "列兵"
        user.pvpLevel = json[kPVPLevel].intValue
        user.silver = json[kSilver].intValue
        user.gold = json[kGold].intValue
        return user
    }
    
    
    
    
}












