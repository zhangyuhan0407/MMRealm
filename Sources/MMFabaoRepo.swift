////
////  MMFabaoRepo.swift
////  MMRealm
////
////  Created by yuhan zhang on 1/14/17.
////
////
//
//import Foundation
//import OCTJSON
//import OCTFoundation
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
