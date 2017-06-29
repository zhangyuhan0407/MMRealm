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
        
        
        self.silver = 1000
        if self.ticket < 2 {
            self.missionLevels = [99010011, 99020101, 99031001, 99049999]
            
            let json1 = JSON.read(fromFile: "\(ShopItemPath)/shopitem_108")!
            let json2 = JSON.read(fromFile: "\(ShopItemPath)/shopitem_106")!
            var item1 = ShopItem.deserialize(fromJSON: json1)
            var item2 = ShopItem.deserialize(fromJSON: json2)
            
            item1.position = 0
            item2.position = 1
            
            self.shopItems = [item1, item2]
            
            
        }
        else {
            self.refreshMission()
            _ = self.refreshShopItems()
        }
        
        
        
        
        return true
        
    }
    
    
    func exitGameState() -> Bool {
        
        let user = self
        user.silver = 0
        user.characters = []
        user.weapons = []
        user.armors = []
        user.trinkets = []
        user.miscs = []
        
        user.displayTitle = "列兵"
        user.gameState = 0
        user.dungeonLevel = 0
        user.missionLevels = []
        user.shopItems = []
        user.pvpLevel = 0
        user.missionCompleteCount = 0
        self.gameState = 0
        
        do {
            try MMUserDAO.sharedInstance.save(self)
        } catch {
            return false
        }
        
        return true
        
    }
    
    
}







