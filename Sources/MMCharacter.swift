//
//  MMCharacter.swift
//  MMClient
//
//  Created by yuhan zhang on 4/9/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


final class MMCharacter: JSONDeserializable {
    
    var name: String {
        return card.name
    }
    
    var story: String {
        return card.story
    }
    
    var imageName: String {
        return card.imageName
    }
    
    var skill1Description: String {
        return card.skill1Description
    }
    
    var skill2Description: String {
        return card.skill2Description
    }
    
    var key: String
    var card: MMCard
    
    
    var weapon: MMWeapon?
    
    var armor: MMArmor?
    
    var trinket: MMTrinket?
    
    var position: Int = 0
    
    
    private init(card: MMCard) {
        self.card = card
        self.key = card.key
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMCharacter {

        
        let card = MMCard(json[kCardKey].stringValue)
        let ret = MMCharacter(card: card)
        
        
        ret.position = json["position"].intValue
        
        
        if let _ = json["weapon"]["key"].string {
            ret.weapon = MMWeapon.deserialize(fromJSON: json["weapon"])
        }
        
        
        if let _ = json["armor"]["key"].string {
            ret.armor = MMArmor.deserialize(fromJSON: json["armor"])
        }
        
        
        if let _ = json["trinket"]["key"].string {
            ret.trinket = MMTrinket.deserialize(fromJSON: json["trinket"])
        }
        
        
        return ret
    }
    
    
    var dict: [String: Any] {
        return [kCardKey: card.key,
                kTrinket: trinket?.dict ?? [:],
                kWeapon: weapon?.dict ?? [:],
                kArmor: armor?.dict ?? [:],
                kPosition: position]
    }
    
    
}







