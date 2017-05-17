//
//  MMCharacter.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTJSON
import Kitura
import OCTFoundation


#if os(Linux)
let BasePath =              "~/Developer/MMRealm"
let UserCharRepoPath =      "~/Developer/MMRealm/UserCharRepo"
let UserRepoPath =          "~/Developer/MMRealm/UserRepo"
let UserFabaoRepoPath =     "~/Developer/MMRealm/UserFabaoRepo"
let UserBagRepoPath =       "~/Developer/MMRealm/UserBagRepo"
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
    
    func send(_ model: OCTResponse) -> RouterResponse {
        return self.send(model.description)
    }
    
}



extension RouterRequest {

    var jsonBody: JSON? {
        do {

            guard let s = try self.readString() else {
                return nil
            }

            return try JSON.deserialize(s)

        } catch {
            return nil
        }
    }

}





func fatalerror(_ s: String = "") {
    fatalError(s)
}




