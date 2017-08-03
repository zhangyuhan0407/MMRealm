//
//  MMUser+Dungeon.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/15/17.
//
//

import Foundation
import OCTFoundation



extension MMUser {
    
    func has(dungeon: Int) -> Bool {
        for d in self.dungeons {
            if d.index == dungeon {
                return true
            }
        }
        return false
    }
    
    
    func has(dungeon: String) -> Bool {
        for d in self.dungeons {
            if d.key == dungeon {
                return true
            }
        }
        return false
    }
    
    
    func find(dungeon: String) -> MYDungeon? {
        for d in self.dungeons {
            if d.key == dungeon {
                return d
            }
        }
        return nil
    }
    
    
    func find(dungeon: Int) -> MYDungeon? {
        return self.find(dungeon: "dungeon_\(dungeon)")
    }
    
    
    func find(dungeon: MYDungeon) -> MYDungeon? {
        return self.find(dungeon: dungeon.key)
    }
    
    
    func add(dungeon: String) -> Bool {
        if self.has(dungeon: dungeon) {
            return false
        }
        
        let d = MYDungeon(key: dungeon)
        self.dungeons.append(d)
        return true
    }
    
    
    
    func unlock(dungeon: String) -> Bool {
        guard let d = self.find(dungeon: dungeon) else {
            return false
        }
        
        
        d.bossIndex = 1
        return true
    }
    
    
    
    
    
    func upgrade(dungeon: MYDungeon) -> Bool {
        
        guard let d = self.find(dungeon: dungeon) else {
            return false
        }
        
        
        d.bossIndex += 1
        return true
        
        
//        
//        
//        
//        let next: Int
//        if level == 107 {
//            next = 200
//        } else if level == 209 {
//            next = 300
//        } else if level == 304 {
//            next = 400
//        } else if level == 404 {
//            next = 500
//        } else if level == 507 {
//            next = 600
//        } else if level == 604 {
//            next = 700
//        } else {
//            next = level + 1
//        }
//        
//        self.dungeonLevel = next
//        
//        return true
    }
    
}







