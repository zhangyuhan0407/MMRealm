//
//  AttackArea.swift
//  AAA
//
//  Created by yuhan zhang on 10/25/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation
import OCTFoundation


struct ENMail: JSONDeserializable {
    
    var key: String
    var index: Int = 0
    
    var sour: String = ""
    var dest: String = ""
    
    var sourDisplayName = ""
    var destDisplayName = ""
    
    var title: String = "..."
    var info: String = ""
    
    var isChecked = false
    
    var rewards: [String] = []
    
    
    init(key: String) {
        self.key = key
    }
    
    
    static func deserialize(fromJSON json: JSON) -> ENMail {
        let key = json["key"].string!
        
        var mail = ENMail(key: key)
        mail.index = json["index"].int ?? 0
        
        mail.sour = json["sour"].string!
        mail.dest = json["dest"].string!
        mail.sourDisplayName = json["sourdisplayname"].string ?? "未知目标"
        mail.destDisplayName = json["destdisplayname"].string ?? "未知目标"
        
        mail.title = json["title"].string ?? "..."
        mail.info = json["info"].string ?? ""
        mail.rewards = json["rewards"].stringArray ?? []
        
        return mail
    }
    
    
    var dict: [String : Any] {
        return ["key": self.key,
                "index": self.index,
                "sour": self.sour,
                "dest": self.dest,
                "sourdisplayname": self.sourDisplayName,
                "destdisplayname": self.destDisplayName,
                "title": self.title,
                "info": self.info,
                "rewards": self.rewards]
    }
    
    
    
    
}







