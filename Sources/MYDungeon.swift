//
//  MYDungeon.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/24/17.
//
//

import Foundation



final class MYDungeon: JSONDeserializable {
    var key: String
    var index: Int
    var bossIndex: Int
    
    
    init(key: String) {
        self.key = key
        self.index = Int(key.components(separatedBy: "_").last!)!
        self.bossIndex = 0
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MYDungeon {
        let k = json["key"].string!
        let d = MYDungeon(key: k)
        d.index = json["index"].int!
        d.bossIndex = json["bossindex"].int!
        
        return d
    }
    
    var dict: [String : Any] {
        return ["key": key, "index": index, "bossindex": bossIndex]
    }
    
}


