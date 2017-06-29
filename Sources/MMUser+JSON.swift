//
//  MMCardModel.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import OCTJSON
import OCTFoundation


extension MMUser {
    
    
    var infoJSON: JSON {
        return JSON(self.dict)
    }


    var charsJSON: JSON {
        var jsons = [JSON]()
        for c in self.characters {
            jsons.append(JSON(c.dict))
        }
        return JSON(jsons)
    }



    var bagJSON: JSON {

        var json = JSON([String: Any]())
        var tempJSON = [JSON]()
        for weapon in self.weapons {
            tempJSON.append(JSON(weapon.dict))
        }

        json["weapon"] = JSON(tempJSON)


        tempJSON = []
        for armor in self.armors {
            tempJSON.append(JSON(armor.dict))
        }

        json["armor"] = JSON(tempJSON)


        tempJSON = []
        for trinket in self.trinkets {
            tempJSON.append(JSON(trinket.dict))
        }
        json["trinket"] = JSON(tempJSON)


        tempJSON = []
        for misc in self.miscs {
            tempJSON.append(JSON(misc.dict))
        }
        json["misc"] = JSON(tempJSON)
        
        json["gold"] = JSON(self.gold)
        json[kSilver] = JSON(self.silver)
        
        return json
        
    }
    
    
    var shopItemJSON: JSON {
        var ret = [JSON]()
        for item in self.shopItems {
            ret.append(item.json)
        }
        return JSON(ret)
    }
    
    
    var missionJSON: JSON {
        let dict: [String: Any] = ["missionlevels": self.missionLevels, "missioncompletecount": missionCompleteCount]
        return JSON(dict)
    }
    
    
    var mailsJSON: JSON {
        return JSON(self.mails.map { $0.json })
    }
    
    
    var json: JSON {
        var json = infoJSON

        json["bag"] = self.bagJSON
        json["chars"] = self.charsJSON

        
        return json
    }
    
}



//struct MMCard: JSONDeserializable {
//    
//    var key: String
//    
//    var imageName: String
//    
//    var name: String
//    
//    var story: String
//    
//    var skill1Description: String
//    
//    var skill2Description: String
//    
//    init(_ key: String) {
//        if key == "" {
//            fatalError()
//        }
//        self.key = key
//        self.imageName = key
//        self.name = key
//        self.story = "这是一个\(key)"
//        skill1Description = "技能1描述"
//        skill2Description = "技能2描述"
//    }
//    
//    
//    
//    var dict: [String : Any] {
//        return [kKey: key,
//                "imagename": imageName,
//                kName: name,
//                "story": story,
//                "skill1description": skill1Description,
//                "skill1description": skill2Description]
//    }
//    
//    
//    static func deserialize(fromJSON json: JSON) -> MMCard {
//        let key = json["key"].stringValue
//        return MMCard(key)
//    }
//    
//}



//struct MMCard: CustomStringConvertible {
//    
//    var key: String
//    
//    var json: JSON {
//        return JSON([kKey: key] as [String: Any])
//    }
//    
//    var description: String {
//        return json.description
//    }
//    
//}



//
//class MMCard: OCTModel {
//    
//    var key: String
//    var name: String
//    
//    var hp = 0
//    var atk = 0
//    var def = 0
//    var mag = 0
//    var spd = 0
//    
//    
//    var ball = 0
//    var category = 0
//    
//    
//    var skill0: String = ""
//    var skill1: String = ""
//    var skill2: String = ""
//    
//    
//    
//    
//    required init(fromDictionary dict: [String : Any]) {
//        
//        self.key = dict[kKey] as! String
//        self.name = dict[kName] as! String
//        
//        self.hp = dict[kHP] as? Int ?? 10
//        self.atk = dict[kATK] as? Int ?? 0
//        self.def = dict[kDEF] as? Int ?? 0
//        self.mag = dict[kMAG] as? Int ?? 0
//        self.spd = dict[kSPD] as? Int ?? 0
//        
//        self.ball = dict[kBall] as? Int ?? 0
//        self.category = dict[kCategory] as? Int ?? 0
//        
//        self.skill0 = dict[kSkill0] as? String ?? ""
//        self.skill1 = dict[kSkill1] as? String ?? ""
//        self.skill2 = dict[kSkill2] as? String ?? ""
//        
//    }
//    
//    
//    func toDictionary() -> [String : Any] {
//        return [kKey: self.key,
//                kName: self.name,
//                kHP: self.hp,
//                kATK: self.atk,
//                kDEF: self.def,
//                kMAG: self.mag,
//                kSPD: self.spd,
//                kBall: self.ball,
//                kCategory: self.category,
//                kSkill0: self.skill0,
//                kSkill1: self.skill1,
//                kSkill2: self.skill2]
//    }
//    
//    
//}
//
//
//class MMCardDAO: OCTDAO {
//    
//    static var sharedInstance = MMCardDAO()
//    
//    private init() {}
//    
//    typealias Model = MMCard
//    
//    static var TableName: String = "cards"
//    
//    static var PrimaryKey: String = "key"
//    
//}





















