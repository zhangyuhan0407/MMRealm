//
//  MMMisc.swift
//  MMClient
//
//  Created by yuhan zhang on 5/3/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import OCTJSON



enum MiscType: String {
    case card
    case prop
    case none
}




struct MMMisc: MMInventory {
    
    var key: String = "DEFAULT_MISC"
    var imageName: String = "default_misc"
    var displayName: String = "默认杂货"
    var category: MMCategory = .misc
    var rarity: MMRarity = .white
    var count: Int = 0
    
    
    var type: MiscType = .none
    var usage: String?
    var story: String?
    
    
    init() {
        
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMMisc {
        
        var ret = MMMisc()
        
        ret.key = json[kKey].stringValue
        ret.imageName = json[kImageName].stringValue
        ret.displayName = json[kDisplayeName].stringValue
        ret.category = MMCategory.deserialize(fromString: json[kCategory].stringValue)
        ret.rarity = MMRarity.deserialize(fromString: json[kRarity].stringValue)
        ret.count = json[kCount].intValue
        
        ret.type = MiscType(rawValue: json[kType].string!)!
        ret.usage = json[kUsage].string
        ret.story = json[kStory].string
        
        return ret
    }
    
    
    var dict: [String : Any] {
        var ret = [kKey: self.key,
                   kImageName: imageName,
                   kDisplayeName: displayName,
                   kCategory: category.description,
                   kRarity: rarity.description,
                   kCount: count,
                   kType: type.rawValue
            ] as [String: Any]
        
        if let usage = self.usage {
            ret.updateValue(usage, forKey: kUsage)
        }
        
        if let story = self.story {
            ret.updateValue(story, forKey: kStory)
        }
        
        return ret
    }
    
    
    mutating func increase(count: Int) {
        self.count += count
    }
    
    mutating func decrease(count: Int) {
        self.count -= count
    }
    
    
    
    
    
    
    
}










