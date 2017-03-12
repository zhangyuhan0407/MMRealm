//
//  MMBaoshi.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation


typealias MMBaoshi = KindLevelType


func ==(baoshi1: KindLevelType, baoshi2: KindLevelType) -> Bool {
    return baoshi1.key == baoshi2.key && baoshi1.level == baoshi2.level
}



struct KindLevelType: CustomStringConvertible {
    
    var key: String
    var level: Int
    
    
    static func deserialize(fromString s: String) -> KindLevelType? {
        
        let array = s.components(separatedBy: "_")
        
        if array.count != 2 {
            return nil
        }
        
        let k = array[0]
        let l = Int(array[1])
        
        if l == nil {
            return nil
        }
        
        return KindLevelType(key: k, level: l!)
        
    }
    
    
    var description: String {
        return "\(key)_\(level)"
    }
    
}




