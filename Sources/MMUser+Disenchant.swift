//
//  MMUser+Disenchant.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/21/17.
//
//

import Foundation


extension MMUser {
    
    
    func disenchant(inv: MMInventory) -> String? {
        if self.remove(inv: inv) == false {
            return nil
        }
        
        if inv.key.contains("CARD") {
            self.add(gold: 100)
            return "PROP_Gold_100"
        } else {
            self.add(silver: 100)
            return "PROP_Silver_100"
        }
        
    }
    
    
    func disenchant(invs: [MMInventory]) -> [String] {
        var ret = [String]()
        for inv in invs {
            if let s = disenchant(inv: inv) {
                ret.append(s)
            }
        }
        return ret
    }
    
    
}
