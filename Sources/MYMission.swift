//
//  MYMission.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/24/17.
//
//

import Foundation


final class MYMission: JSONDeserializable {
    var key: String
    var index: Int
//    var level: Int
    var bossIndex: Int
    var rewardIndex: Int
    var type: String = "pve"
    var enemyUserKey = ""
    var enemyUserDisplayName = ""
    
    
    init(key: String) {
        self.key = key
        self.index = Int(key.components(separatedBy: "_").last!)!
//        self.level = 0
        self.bossIndex = 0
        self.rewardIndex = 0
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MYMission {
        let k = json["key"].string!
        let m = MYMission(key: k)
        m.index = json["index"].int!

        m.bossIndex = json["bossindex"].int!
        m.rewardIndex = json["rewardindex"].int!
        m.type = json["type"].string ?? "pve"
        
        m.enemyUserKey = json["enemyuserkey"].string ?? ""
        m.enemyUserDisplayName = json["enemyuserdisplayname"].string ?? ""
        
        return m
    }
    
    var dict: [String : Any] {
        return ["key": key,
                "index": index,
                "bossindex": bossIndex,
                "rewardindex": self.rewardIndex,
                "type": type,
                "enemyuserkey": enemyUserKey,
                "enemyuserdisplayname": enemyUserDisplayName]
    }
    
}







