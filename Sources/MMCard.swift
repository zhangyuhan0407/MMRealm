//
//  MMCard.swift
//  MMClient
//
//  Created by yuhan zhang on 4/13/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MMCardType {
    case FS
    case MS
    case SS
    case DZ
    case XD
    case LR
    case SM
    case ZS
    case QS
}


struct MMCard: JSONDeserializable {
    
    var key: String
    
    var imageName: String
    
    var name: String
    
    var story: String
    
    var skill1Description: String
    
    var skill2Description: String
    
    init(_ key: String) {
        if key == "" {
            fatalError()
        }
        self.key = key
        self.imageName = key
        self.name = key
        self.story = "这是一个\(key)"
        skill1Description = "技能1描述"
        skill2Description = "技能2描述"
    }
    
    
    var dict: [String : Any] {
        return [kKey: key,
                kImageName: imageName,
                kName: name,
                kStory: story,
                kSkill1Description: skill1Description,
                kSkill2Description: skill2Description]
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMCard {
        let key = json[kKey].stringValue
        var card = MMCard(key)
        card.imageName = json[kImageName].string ?? key
        card.name = json[kName].stringValue
        card.story = json[kStory].stringValue
        card.skill1Description = json[kSkill1Description].stringValue
        card.skill2Description = json[kSkill2Description].stringValue
        return card
    }
    
}







