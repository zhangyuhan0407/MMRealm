//
//  MMUser+GameState.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/15/17.
//
//

import Foundation
import OCTFoundation
import OCTJSON


extension MMUser {
    
    
    func enterGameState() -> Bool {
        self.gameState = 1
        
        
        self.silver = 5000
        
        
//        if self.ticket < 2 {
//            self.missionLevels = [99010011, 99020101, 99031001, 99049999]
//            
//            let json1 = JSON.read(fromFile: "\(ShopItemPath)/shopitem_108")!
//            let json2 = JSON.read(fromFile: "\(ShopItemPath)/shopitem_106")!
//            var item1 = ENShopItem.deserialize(fromJSON: json1)
//            var item2 = ENShopItem.deserialize(fromJSON: json2)
//            
//            item1.position = 0
//            item2.position = 1
//            
//            self.shopItems = [item1, item2]
//            
//            
//        }
//        else {
//            self.title = self.rankTitle()
//            self.day = 1
//            self.moveToken = self.maxMoveToken
//            _ = self.refreshShopItems()
//        }
        
        self.title = self.rankTitle()
        self.day = 1
        self.moveToken = self.maxMoveToken
        _ = self.refreshShopItems()
        
        
        self.missions = [MYMission(key: "mission_1")]
        self.dungeons = [MYDungeon(key: "dungeon_3")]
        
        
        return true
        
    }
    
    
    @discardableResult
    func exitGameState() -> Bool {
        
        let user = self
        user.silver = 0
        
        user.characters = []
        user.weapons = []
        user.armors = []
        user.trinkets = []
        user.miscs = []
        
        user.title = 0
        user.area = "area_1"
        user.day = 0
        user.moveToken = 0
        
        user.gameState = 0
        
        user.bot = ENBot()
        
        user.dungeons = []
        user.missions = []
        user.shopItems = []

        
        
        for h in self.herilooms {
            _ = self.add(inv: h)
        }
        
        do {
            try MMUserDAO.sharedInstance.save(self)
        } catch {
            return false
        }
        
        return true
        
    }
    
    
}







