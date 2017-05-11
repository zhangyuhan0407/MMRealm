//
//  MMDungeon.swift
//  MMClient
//
//  Created by yuhan zhang on 4/29/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


struct MMDungeon {
    
    var json: JSON
    
    var key: String! { return json["key"].stringValue }
    
    var index: Int! { return json["index"].intValue }
    
    var icon: String! { return json["icon"].stringValue }
    
    var title: String! { return json["title"].stringValue }
    
    var stroy: String! { return json["story"].stringValue }

    var boss: [String]! { return json["boss"].stringArray! }
    
    func characters(forBoss boss: String) -> [MMCharacter] {
        let array = json["characters"][boss].array!
        
        var ret = [MMCharacter]()
        for json in array {
            ret.append(MMCharacter.deserialize(fromJSON: json))
        }
        
        return ret
    }
    
    
    func slots(forBoss boss: String) -> [String] {
        return json["slots"][boss].stringArray!
    }
    
    
    
    private init(json: JSON) {
        self.json = json
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMDungeon {
        
        let ret = MMDungeon(json: json)
        
        return ret
    }
    
}










