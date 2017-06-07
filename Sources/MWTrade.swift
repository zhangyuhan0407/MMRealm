//
//  MMFabaoRepo.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMTradeMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"] else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        guard let json = request.jsonBody
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        func toDictionary(json: JSON) -> [String: Any] {
            
            
            let gold = json[kGold].int ?? 0
            let silver = json[kSilver].int ?? 0
            
            
            var weapons = [MMWeapon]()
            for j in json[kWeapons].array! {
                weapons.append(MMWeapon.deserialize(fromJSON: j))
            }
            
            var armors = [MMArmor]()
            for j in json[kArmors].array! {
                armors.append(MMArmor.deserialize(fromJSON: j))
            }
            
            var trinkets = [MMTrinket]()
            for j in json[kTrinkets].array! {
                trinkets.append(MMTrinket.deserialize(fromJSON: j))
            }
            
            var miscs = [MMMisc]()
            for j in json[kMiscs].array! {
                miscs.append(MMMisc.deserialize(fromJSON: j))
            }
            
            
            
            var ret = [String: Any]()
            ret.updateValue(gold, forKey: "gold")
            ret.updateValue(silver, forKey: kSilver)
            ret.updateValue(weapons, forKey: "weapons")
            ret.updateValue(armors, forKey: "armors")
            ret.updateValue(trinkets, forKey: "trinkets")
            ret.updateValue(miscs, forKey: "miscs")
            
            return ret
        }
        
        let gain = toDictionary(json: json["gain"])
        let cost = toDictionary(json: json["cost"])
        
        do {
            try user.updateBag(gain: gain, cost: cost)
        } catch {
            fatalError()
        }
        
        
        try response.send(OCTResponse.EmptyResult).end()
        
        
        
        
    }
    
    
    
}







//
//
//enum MMCategory: CustomStringConvertible {
//    case weapon
//    case armor
//    case trinket
//    case misc
//
//    
//    var description: String {
//        switch self {
//        case .weapon:
//            return "weapon"
//        case .armor:
//            return "armor"
//        case .trinket:
//            return "trinket"
//        case .misc:
//            return "misc"
//        }
//    }
//    
//    static func deserialize(fromString s: String) -> MMCategory {
//        switch s {
//        case "weapon":
//            return .weapon
//        case "armor":
//            return .armor
//        case "trinket":
//            return .trinket
//        case "misc":
//            return .misc
//        default:
//            fatalError()
//        }
//    }
//}
//
//
//enum MMRarity: CustomStringConvertible {
//    case white
//    case green
//    case blue
//    case orange
//    
//    
//    var description: String {
//        switch self {
//        case .green:
//            return "green"
//        case .blue:
//            return "blue"
//        case .orange:
//            return "orange"
//        default:
//            return "white"
//        }
//    }
//    
//    static func deserialize(fromString s: String) -> MMRarity {
//        switch s {
//        case "green":
//            return .green
//        case "blue":
//            return .blue
//        case "orange":
//            return .orange
//        default:
//            return .white
//        }
//    }
//}
//
//
//
//protocol JSONDeserializable: CustomStringConvertible {
//    static func deserialize(fromJSON json: JSON) -> Self
//    var json: JSON { get }
//    var dict: [String: Any] { get }
//}
//
//
//extension JSONDeserializable {
//    var description: String {
//        return json.description
//    }
//    
//    var json: JSON {
//        return JSON(dict)
//    }
//}
//
//
//protocol MMInventory: JSONDeserializable {
//    
//    var key: String { get set }
//    var imageName: String { get set }
//    var category: MMCategory { get set }
//    var rarity: MMRarity { get set }
//    
//    var count: Int { get set }
//    
//}
//
//
//
//struct MMFaBao: MMInventory {
//    
//    var key: String
//    var imageName: String
//    var category: MMCategory
//    var rarity: MMRarity
//    var count: Int
//    
//    init(key: String, category: MMCategory, rarity: MMRarity) {
//        self.key = key
//        self.imageName = key
//        self.category = category
//        self.rarity = rarity
//        self.count = 0
//    }
//    
//    
//    static func deserialize(fromJSON json: JSON) -> MMFaBao {
//        
//        let key = json["key"].string!
//        let category = json["category"].string!
//        let rarity = json["rarity"].string!
//        
//        let ret = MMFaBao(key: key,
//                          category: MMCategory.deserialize(fromString: category),
//                          rarity: MMRarity.deserialize(fromString: rarity))
//        
//        return ret
//    }
//    
//    
//    var dict: [String : Any] {
//        return ["key": key,
//                "imagename": imageName,
//                "category": category.description,
//                "rarity": rarity.description,
//                "count": count] as [String: Any]
//    }
//    
//    
//    static func defaultInstance() -> MMFaBao {
//        let ret = MMFaBao(key: "INV_Belt_01", category: .armor, rarity: .blue)
//        return ret
//    }
//    
//    
//}
//
//
//typealias MMWeapon = MMFaBao
//typealias MMTrinket = MMFaBao
//typealias MMArmor = MMFaBao
//typealias MMMisc = MMFaBao
//
//
//
//
//
//
//
