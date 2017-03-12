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


struct MMCard: CustomStringConvertible {
    var key: String
    
    var json: JSON {
        return JSON([kKey: key] as [String: Any])
    }
    
    var description: String {
        return json.description
    }
    
}



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





















