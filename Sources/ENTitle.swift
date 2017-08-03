//
//  ENExplore.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation
import OCTJSON

//
//enum ENTitle: Int {
//    
//    case level0 = 0
//    case level1 = 1
//    case level2 = 2
//    case level3 = 3
//    case level4 = 4
//    case level5 = 5
//    case level6 = 6
//    case level7 = 7
//    
//    
//    var displayName: String {
//        switch self {
//        case .level0:
//            return "奴隶"
//        case .level1 :
//            return "工人"
//        case .level2 :
//            return "贸易商"
//        case .level3 :
//            return "贸易阶级"
//        case .level4 :
//            return "奴隶主"
//        case .level5 :
//            return "男爵"
//        case .level6 :
//            return "巨头"
//        case .level7 :
//            return "贸易亲王"
//        }
//    }
//    
//    
//    
//    var moveToken: Int {
//        switch self {
//        case .level0:
//            return 0
//        case .level1:
//            return 3
//        case .level2:
//            return 4
//        case .level3:
//            return 4
//        case .level4:
//            return 5
//        case .level5:
//            return 5
//        case .level6:
//            return 6
//        case .level7:
//            return 7
//        }
//    }
//    
//}
//
//


final class ENTitle: JSONDeserializable {
    var key = "DEFAULT_TITLE"
    var id = 0
    var level = 0
    var imageName = "DEFAULT_TITLE"
    
    var displayName = "默认头衔"
    var features: [String] = []
    var story = ""
    
    
    static func deserialize(fromJSON json: JSON) -> ENTitle {
        let ret = ENTitle()
        ret.key = json["key"].string!
        ret.id = json["id"].int!
        ret.level = json["id"].int!
        ret.imageName = json["imagename"].string!
        ret.displayName = json["displayname"].string!
        
        ret.features = json["features"].stringArray!
        ret.story = json["story"].string!
        
        return ret
    }
    
    
    var dict: [String : Any] {
        return ["key": key,
                "id": id,
                "level": level,
                "imagename": imageName,
                "displayname": displayName,
                "features": features,
                "story": story]
    }
    
    
    
}













