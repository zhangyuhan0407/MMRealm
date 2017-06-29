//
//  OCTModel.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/28/16.
//  Copyright © 2016 octopus. All rights reserved.
//


import OCTJSON
import OCTFoundation

extension MMUser {
    
    
    private func hasTicket() -> Bool {
        return self.ticket > 0
    }
    
    
    @discardableResult
    private func add(ticket: Int) -> Bool {
        self.ticket += ticket
        return true
    }
    
    
    private func remove(ticket: Int) -> Bool {
        if self.ticket < ticket {
            return false
        }
        
        self.ticket -= ticket
        return true
    }
    
    
    
    
    func buyTicket(count: Int, gold: Int) -> Bool {
        
        let isSucceed = self.remove(gold: gold)
        if isSucceed == false {
            return false
        }
        
        self.add(ticket: count)
        
        return true
    }
    
    
    func useTicket(count: Int = 1) -> Bool {
        return self.remove(ticket: count)
    }
    
    
    
}











