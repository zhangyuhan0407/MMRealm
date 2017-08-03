//
//  MMUser+Title.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTJSON
import OCTFoundation


extension MMUser {
    
    func rankTitle() -> Int {
        
        
        var goldLevel = 0
        if self.gold < 1000 {
            goldLevel = 1
        }
        else if self.gold < 2000 {
            goldLevel = 2
        }
        else if self.gold < 5000 {
            goldLevel = 3
        }
        else if self.gold < 10000 {
            goldLevel = 4
        }
        else if self.gold < 20000 {
            goldLevel = 5
        }
        else if self.gold < 50000 {
            goldLevel = 6
        }
        else if self.gold < 500000 {
            goldLevel = 7
        }
        
        
        var vip = 0
        if self.vipLevel < 100 {
            vip = 1
        }
        else if self.vipLevel < 500 {
            vip = 2
        }
        else if self.vipLevel < 1000 {
            vip = 3
        }
        else if self.vipLevel < 2000 {
            vip = 4
        }
        else if self.vipLevel < 10000 {
            vip = 5
        }
        else if self.vipLevel < 50000 {
            vip = 6
        }
        else {
            vip = 7
        }
        
        let ret = max(vip, goldLevel)
        
        let json = JSON.read(fromFile: "\(TitlePath)/title_\(ret)")!
        self.displayTitle = json["displayname"].string!
        
        return ret
        
    }
    
    
    func goldFromSub() -> Int {
        switch self.title {
        case 1:
            return 80.wave(percent: 15)
        case 2:
            return 144.wave(percent: 15)
        case 3:
            return 300.wave(percent: 15)
        case 4:
            return 480.wave(percent: 15)
        case 5:
            return 928.wave(percent: 15)
        case 6:
            return 1600.wave(percent: 15)
        case 7:
            return 3400.wave(percent: 15)
        default:
            return 0
        }
    }
    
  
    func silverForCompony() -> Int {
        return 5000
    }
    
    
    
}








