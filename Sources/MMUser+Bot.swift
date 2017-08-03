//
//  MMUser+Bot.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation



extension MMUser {
    
    func upgradeBotArmyCount() -> Bool {
        
        if self.bot.maxArmyCount == 8 {
            return false
        }
        
        self.bot.maxArmyCount += 1
        return true
    }
    
    
    
}
