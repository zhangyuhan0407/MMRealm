//
//  MMFabao+Service.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation


extension MMFabao {
    
    mutating func addBaoshi(baoshi: MMBaoshi) -> Bool {
        if self.baoshi.count < baoshiCount {
            self.baoshi.append(baoshi)
            return true
        }
        
        return false
    }
    
    mutating func removeBaoshi(baoshi: MMBaoshi) -> Bool {
        var removedIndex = -1
        
        for i in 0..<self.baoshi.count {
            if self.baoshi[i] == baoshi {
                removedIndex = i
                break
            }
        }
        
        if removedIndex < 0 {
            return false
        }
        
        self.baoshi.remove(at: removedIndex)
        
        return true
        
    }
    
}
