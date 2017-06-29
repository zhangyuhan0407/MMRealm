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
        
        
        guard let key = request.parameters["key"],
            let id = (request.parameters["battleid"]),
            let battleid = Int(id)
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        if battleid < user.dungeonLevel {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let json = request.jsonBody
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        user.upgrade(dungeon: battleid)
        
        let slotJSONs: [JSON] = user.gainSlots(keys: json["slots"].stringArray!)
        
        let ret: [String: Any] = ["slots": JSON(slotJSONs), "dungeonlevel": user.dungeonLevel]
        
        try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        

        
        
        
    }
    
    
    
}










