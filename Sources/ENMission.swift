////
////  AttackRule.swift
////  AAA
////
////  Created by yuhan zhang on 10/25/16.
////  Copyright © 2016 octopus. All rights reserved.
////
//
//import Foundation
//import OCTFoundation
//
//
//
//struct ENMission: JSONDeserializable {
//    
//    var key: String
//    var index: Int = 0
//    var level: Int = 1
//    
//    var json: JSON
//    
//    var icon: String {
//        return json["icon"].string!
//    }
//    var title: String {
//        return json["title"].string!
//    }
//    var story: String {
//        return json["story"].string!
//    }
//    
//    
//    var boss: String {
//        let bosses = json["boss"].stringArray!
//        if level >= bosses.count {
//            return bosses.last!
//        }
//        else {
//            return bosses[level]
//        }
//        
//    }
//    
//    
//    var slots: [String: [String]] {
//        
//    }
//
//    var characters: [String: [[String: Any]]] = [:]
//    
//    
//    init(json: JSON, level: Int) {
//        self.key = json[kKey].string!
//        self.level = level
//        self.index = json["index"].int ?? 0
//    }
//    
//    
//    
//    static func deserialize(fromJSON json: JSON) -> ENMission {
//        var ret = ENMission(key: json[kKey].string!)
//        ret.index = json["index"].int ?? 1
//        ret.level = json["level"].int ?? 1
//        ret.icon = json["icon"].string ?? ret.key
//        ret.title = json["title"].string ?? ret.key
//        ret.story = json["story"].string ?? ret.key
//        ret.boss = json["boss"].stringArray!
//        for slot in
//        ret.slots =
//        
//        
//    }
//    
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
