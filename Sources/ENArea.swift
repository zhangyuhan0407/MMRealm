//
//  ENArea.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation
import OCTJSON



typealias MYNPC = ENNPC


class ENNPCRepo {
    static var sharedInstance = ENNPCRepo()
    
    init() {
        load()
    }
    
    
    private func load() {
        let json = JSON.read(fromFile: "\(NPCPath)")!
        npcs = ENNPC.deserialize(fromJSONArray: json)
    }
    
    var npcs = [ENNPC]()
    
    func find(key: String) -> ENNPC? {
        for npc in self.npcs {
            if npc.key == key {
                return npc
            }
        }
        return nil
    }
    
    
    func random(count: Int) -> [ENNPC] {
        let indexs = Int.random(count: count, max: npcs.count)
        return indexs.map { npcs[$0] }
    }
    
}



struct ENNPC: JSONDeserializable {
    var key: String = "DEFAULT_NPC"
    
    var emotion = "none"
    var name = ""
    
    var displayName: String {
        let e = EmotionType.deserialize(fromString: emotion)
        return "\(e.displayName)\(name)"
    }
    
    
    static func deserialize(fromJSON json: JSON) -> ENNPC {
        var npc = ENNPC()
        npc.key = json["key"].string!
        npc.emotion = json["emotion"].string ?? "none"
        npc.name = json["name"].string!
        return npc
    }
    
    
    var dict: [String : Any] {
        return ["key": key, "emotion": emotion, "name": name]
    }
    
}




final class MYArea: JSONDeserializable {
    var key: String = "DEFAULT_AREA"
    var reputation: Int = 0
    var investments: [MYInvestment] = []
    var npc: [MYNPC] = []
    
    
    static func deserialize(fromJSON json: JSON) -> MYArea {
        let ret = MYArea()
        ret.key = json["key"].string!
        ret.reputation = json["reputation"].int!
        ret.investments = MYInvestment.deserialize(fromJSONArray: json["investments"])
        ret.npc = ENNPC.deserialize(fromJSONArray: json["npc"])
        
        return ret
    }
    
    var dict: [String : Any] {
        return ["key": key, "reputation": reputation,
                "investments": MYInvestment.arrayToJSON(array: investments),
                "npc": ENNPC.arrayToJSON(array: npc)]
    }
    
}




final class ENArea: JSONDeserializable {
    
    var key: String = "DEFAULT_AREA"
    var displayName: String = "默认地区"
    var id: Int = 0
    
    var missions: [String] = []
    var dungeons: [String] = []
    var materials: [String] = []
    var characters: [String] = []
    var herilooms: [String] = []
    var investments: [String] = []
    var npc: [String] = []
    
    
    init() {}
    
    
    static func deserialize(fromJSON json: JSON) -> ENArea {
        let area = ENArea()
        
        area.key = json["key"].string!
        area.displayName = json["displayname"].string!
        area.id = json["id"].int!
        
        area.missions = json["missions"].stringArray ?? []
        area.dungeons = json["dungeons"].stringArray ?? []
        area.materials = json["materials"].stringArray ?? []
        area.characters = json["characters"].stringArray ?? []
        area.herilooms = json["herilooms"].stringArray ?? []
        area.investments = json["investments"].stringArray ?? []
        area.npc = json["npc"].stringArray ?? []

        return area
    }
    
    var dict: [String : Any] {
        return ["key": key,
                "displayname": displayName,
                "id": id,
                "missions": missions,
                "dungeons": dungeons,
                "materials": materials,
                "characters": characters,
                "herilooms": herilooms,
                "investments": investments,
                "npc": npc]
    }
    
}








