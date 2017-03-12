//
//  MMCharacter.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation

import OCTJSON
import OCTFoundation


class MMCharacter {
    
    var card: String
    var position: Int
    var fabao: String
    
    
    init(card: String, position: Int, fabao: String) {
        self.card = card
        self.position = position
        self.fabao = fabao
    }
    
    
    var json: JSON {
        return JSON(["card": card, "position": position, "fabao": fabao])
    }
    
    
}


extension MMCharacter {
    
    static func deserialize(fromJSON json: JSON) -> MMCharacter? {
        guard let card = json["card"].string,
                let position = json["position"].int,
                let fabao = json["fabao"].string
        else {
            return nil
        }
        
        return MMCharacter(card: card, position: position, fabao: fabao)
    }
    
    
}






