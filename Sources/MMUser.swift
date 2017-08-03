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
    
    var key: String = ""
    var lastLogin: Date = Date()
    var token: String = ""
    var displayName = ""
    var displayTitle = ""
    var displayArea = ""
    
    
    var gold = 0
    var silver = 0
    var vipLevel = 0
    
    
    
    
    var title = 0
    var area = "area_1"
    var day: Int = 0
    var moveToken = 0
    
    var herilooms: [MMInventory] = []
    
    
    
    var bot = ENBot()
    
    var gameState = 0
    var ticket = 0
    
    
    
    var shopItems: [ENShopItem] = []
    var mails: [ENMail] = []
    var dungeons: [MYDungeon] = []
    var missions: [MYMission] = []
    var investments: [MYInvestment] = []
    var areas: [MYArea] = []
    
    var emotion = [0,0,0,0,0,0,0]
    
    
    var maxMoveToken: Int {
        
        switch title {
        case 1:
            return 3
        case 2:
            return 4
        case 3:
            return 4
        case 4:
            return 5
        case 5:
            return 5
        case 6:
            return 6
        case 7:
            return 7
        default:
            return 0
        }
    
    }
    
    
    var maxArmyCount: Int {
        return self.bot.maxArmyCount
    }
    
    
    var maxCharCount: Int {
        return self.characters.count
    }
    
    
    
   

    
    var weapons: [MMWeapon] = []
    
    var armors: [MMArmor] = []
    
    var trinkets: [MMTrinket] = []
    
    var miscs: [MMMisc] = []
    
    
    
    var characters = [MMCharacter]()
    
    
    
    init() { }
    
    
    
    var dict: [String : Any] {
        
        return [kKey: self.key,
                kLastLogin: self.lastLogin.description,
                kToken: self.token,
                kDisplayeName: self.displayName,
                "displaytitle": self.displayTitle,
                "displayarea": self.displayArea,
                
                kSilver: self.silver,
                kGold: self.gold,
            
                "title": self.title,
                "area": area,
                "day": self.day,
                "movetoken": self.moveToken,

                "ticket": self.ticket,
                "gamestate": self.gameState,
                "emotion": self.emotion,
                
                "maxmovetoken": self.maxMoveToken,
                "maxarmycount": self.maxArmyCount]
        
    }
    
    
    
    
    static func deserialize(fromJSON json: JSON) -> MMUser {
        let user = MMUser()
        user.key = json[kKey].stringValue
        user.lastLogin = Date()
        user.token = json[kToken].string!
        user.displayName = json["displayname"].string ?? "麦田守望者"
        user.displayTitle = json["displaytitle"].string ?? ""
        user.displayArea = json["displayarea"].string ?? ""
        
        user.silver = json[kSilver].intValue
        user.gold = json[kGold].intValue
        
        
        user.title = json["title"].int ?? 0
        user.area = json["area"].string ?? "area_1"
        user.day = json["day"].int!
        user.moveToken = json["movetoken"].int!
        
        
        user.ticket = json["ticket"].int ?? 0
        user.gameState = json["gamestate"].int ?? 0
        user.emotion = json["emotion"].intArray ?? [0,0,0,0,0,0,0]
        
        
        return user
    }
    
    
    
    
}












