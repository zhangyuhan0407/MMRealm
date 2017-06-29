//
//  MMUser+Prop.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/15/17.
//
//

import Foundation
import OCTFoundation



extension MMUser {
    
    @discardableResult
    func add(gold: Int) -> Bool {
        self.gold += gold
        return true
    }
    
    
    func remove(gold: Int) -> Bool {
        if self.gold < gold {
            return false
        }
        
        self.gold -= gold
        return true
        
    }
    
    @discardableResult
    func add(silver: Int) -> Bool {
        self.silver += silver
        return true
    }
    
    
    func remove(silver: Int) -> Bool {
        if self.silver < silver {
            return false
        }
        
        self.silver -= silver
        return true
    }
    
    
}





