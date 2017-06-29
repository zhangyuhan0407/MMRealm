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
    let BasePath =              "/home/ubuntu/Developer/MMRealm"
    let UserCharRepoPath =      "/home/ubuntu/Developer/MMRealm/UserCharRepo"
    let UserRepoPath =          "/home/ubuntu/Developer/MMRealm/UserRepo"
    let UserFabaoRepoPath =     "/home/ubuntu/Developer/MMRealm/UserFabaoRepo"
    let UserBagRepoPath =       "/home/ubuntu/Developer/MMRealm/UserBagRepo"
    let UserMailBoxPath =       "/home/ubuntu/Developer/MMRealm/UserMailBoxRepo"
    
    
    let INVPath =               "/home/ubuntu/Developer/MMFileServer/invs"
    let CardPath =              "/home/ubuntu/Developer/MMFileServer/cards"
    let ShopItemPath =          "/home/ubuntu/Developer/MMFileServer/ShopItems"
#else
    let BasePath =              "/Users/yorg/Developer/MMRealm"
    let UserCharRepoPath =      "/Users/yorg/Developer/MMRealm/UserCharRepo"
    let UserRepoPath =          "/Users/yorg/Developer/MMRealm/UserRepo"
    let UserFabaoRepoPath =     "/Users/yorg/Developer/MMRealm/UserFabaoRepo"
    let UserBagRepoPath =       "/Users/yorg/Developer/MMRealm/UserBagRepo"
    let UserMailBoxPath =       "/Users/yorg/Developer/MMRealm/UserMailBoxRepo"
    
    
    let INVPath =               "/Users/yorg/Developer/MMFileServer/invs"
    let CardPath =              "/Users/yorg/Developer/MMFileServer/cards"
    let ShopItemPath =          "/Users/yorg/Developer/MMFileServer/ShopItems"
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
    
    func send(_ json: JSONDeserializable) -> RouterResponse {
        return self.send(OCTResponse.Succeed(data: json.json))
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







extension MMMisc {
    static func create(fromKey key: String) -> MMMisc {
        let json = JSON.read(fromFile: "\(INVPath)/\(key)")!
        
        let ret = MMMisc.deserialize(fromJSON: json)
        
        return ret
    }
}


extension Int {
    public static func random(max: Int = 100) -> Int {
        #if os(Linux)
            return Int(Glibc.random() % max)
        #else
            return Int(arc4random() % UInt32(max))
        #endif
    }
}


struct OORandom {
    
    static func happens(inPosibility number: Int) -> Bool {
        if Int.random() < number {
            return true
        }
        
        return false
    }
    
}










