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
        
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        }
        else if method == "post" {
            try post(request: request, response: response, next: next)
        }
        else if method == "put" {
            try put(request: request, response: response, next: next)
        }
        else if method == "delete" {
            try delete(request: request, response: response, next: next)
        }
        
        
        
    }
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
    }
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
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
        
        
        
//        let gain = toDictionary(json: json["gain"])
        let inv = MMInventoryRepo.create(withKey: json["result"].string!)
        let cost = MMInventoryRepo.toDictionary(json: json["cost"])
        
        do {
            if inv.key.contains("Weapon") {
                try user.updateBag(gain: ["weapons": [inv]], cost: cost)
            }
            else if inv.key.contains("Armor") {
                try user.updateBag(gain: ["armors": [inv]], cost: cost)
            }
            else {
                try user.updateBag(gain: ["trinkets": [inv]], cost: cost)
            }
            try response.send(OCTResponse.Succeed(data: inv.json)).end()
        } catch {
            try response.send(OCTResponse.DatabaseError).end()
        }
        
        
        
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
    }
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
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
