//
//  MMUser.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import OCTJSON
import OCTFoundation
import Kitura



class MMDungeonMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
        guard let key = request.parameters["key"]
        else {
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
        
        
        let myDungeon = MYDungeon.deserialize(fromJSON: json["mydungeon"])
        
        let isSucceed = user.upgrade(dungeon: myDungeon)
        
        if isSucceed {
            let slotJSONs: [JSON] = user.gainSlots(keys: json["slots"].stringArray!)
            
            let ret: [String: Any] = ["slots": JSON(slotJSONs), "mydungeon": myDungeon.json]
            
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        }
        else {
            try response.send(OCTResponse.InputFormatError).end()
        }

        
    }
    
    
    
}










