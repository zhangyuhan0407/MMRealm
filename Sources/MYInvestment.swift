//
//  MYInvestment.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/27/17.
//
//

import Foundation
import OCTFoundation
import OCTJSON



final class MYInvestment: JSONDeserializable {
    
    var key: String = "DEFAULT_INVESTMENT"
    var progress = 0
    
    static func deserialize(fromJSON json: JSON) -> MYInvestment {
        let ret = MYInvestment()
        ret.key = json["key"].string!
        ret.progress = json["progress"].int!
        
        return ret
    }
    
    var dict: [String : Any] {
        return ["key": key, "progress": progress]
    }
    
    
}

