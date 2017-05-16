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
import Kitura




#if os(Linux)
let BasePath =              "/root/Developer/MMRealm"
let UserCharRepoPath =      "/root/Developer/MMRealm/UserCharRepo"
let UserRepoPath =          "/root/Developer/MMRealm/UserRepo"
let UserFabaoRepoPath =     "/root/Developer/MMRealm/UserFabaoRepo"
let UserBagRepoPath =       "/root/Developer/MMRealm/UserBagRepo"
#else
let BasePath =              "/Users/yorg/Developer/MMRealm"
let UserCharRepoPath =      "/Users/yorg/Developer/MMRealm/UserCharRepo"
let UserRepoPath =          "/Users/yorg/Developer/MMRealm/UserRepo"
let UserFabaoRepoPath =     "/Users/yorg/Developer/MMRealm/UserFabaoRepo"
let UserBagRepoPath =       "/Users/yorg/Developer/MMRealm/UserBagRepo"
#endif


typealias JSON = Json


extension JSON {
    var stringValue: String {
        return self.string!
    }
    
    var intValue: Int {
        return self.int!
    }
}


extension RouterResponse {
    
    //    func send(_ model: OCTModel) -> RouterResponse {
    //        return self.send(JSON(model.toDictionary()).description)
    //    }
    
    //    func send(_ s: CustomStringConvertible) -> RouterResponse {
    //        return self.send(s.description)
    //    }
    
    func send(_ model: OCTResponse) -> RouterResponse {
        return self.send(model.description)
    }
    
}




func fatalerror(_ s: String = "") {
    fatalError(s)
}




