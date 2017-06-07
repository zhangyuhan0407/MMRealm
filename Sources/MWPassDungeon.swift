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
        
        
        if battleid <= user.dungeonLevel {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let json = request.jsonBody
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        
        user.upgrade(dungeon: battleid)
        
        var ret: [JSON] = user.gainSlots(keys: json["slots"].stringArray!)
        
        let slotKeys = json["slots"].stringArray!
        
//        var ret = [JSON]()
//        for slotKey in slotKeys {
//            
//            if slotKey.contains("CARD") {
//                
//                let misc: MMMisc
//                if slotKey.contains("Random") {
//                    let cls = randomCls()
//                    misc = MMMisc.create(fromKey: "CARD_\(cls)")
//                }
//                else {
//                    misc = MMMisc.create(fromKey: slotKey)
//                }
//                
//                
//                
//                user.add(misc: misc, count: 1)
//                ret.append(misc.json)
//                
//                continue
//            }
//            
//            else if slotKey.contains("PROP") {
//
//                let count = Int(slotKey.components(separatedBy: "_").last!)!
//                
//                if slotKey.contains("Gold") {
//                    user.add(gold: count)
//                }
//                else if slotKey.contains("Silver") {
//                    user.add(silver: count)
//                }
//                else {
//                    fatalError()
//                }
//                
//            }
//            
//            else if slotKey.contains("INV") {
//                if Int.random() < 10 {
//                    
//                    let inv = MMInventoryRepo.create(withKey: slotKey)
//                    
//                    ret.append(inv.json)
//                }
//            }
//            
//            else {
//                fatalError()
//            }
//            
//            
//        }
        
        
        
        
        try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        

        
        
        
    }
    
    
    
}










