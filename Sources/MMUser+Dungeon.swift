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
    
    func upgrade(dungeon level: Int) -> Bool {
        
        let next: Int
        if level == 107 {
            next = 200
        } else if level == 209 {
            next = 300
        } else if level == 304 {
            next = 400
        } else if level == 404 {
            next = 500
        } else if level == 507 {
            next = 600
        } else if level == 604 {
            next = 700
        } else {
            next = level + 1
        }
        
        self.dungeonLevel = next
        
        return true
    }
    
}
