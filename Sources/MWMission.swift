//
//  MMBaoshiMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMMissionMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        } else if method == "post" {
            try post(request: request, response: response, next: next)
        } else if method == "put" {
            try put(request: request, response: response, next: next)
        } else if method == "delete" {
            try delete(request: request, response: response, next: next)
        }
        else {
            try response.send(OCTResponse.InputFormatError).end()
        }
        
    }
    
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: user.missionJSON)).end()
        
    }
    
    
    //通关
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"],
            let id = request.parameters["missionid"],
            let missionID = Int(id)
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
//        if missionID < 0 {
//            let isSucceed = user.refreshMission()
//            if isSucceed {
//                _ = user.remove(silver: 100)
//                let dict: [String: Any] = ["missionlevels": user.missionLevels]
//                try response.send(OCTResponse.Succeed(data: JSON(dict))).end()
//                return
//            }
//            else {
//                try response.send(OCTResponse.ServerError).end()
//                return
//            }
//        }
        
            
//        else {
            if user.has(mission: missionID) {
                
                guard let json = request.jsonBody else {
                    try response.send(OCTResponse.InputFormatError).end()
                    return
                }
                
                
                let slotKeys = json["slots"].stringArray!
                
                
                let isSucceed = user.complete(mission: missionID)
                
                if isSucceed {
                    
                    var ret = user.missionJSON
                    
                    ret["slots"] = JSON(user.gainSlots(keys: slotKeys))
                    
                    try response.send(OCTResponse.Succeed(data: ret)).end()
                    
                    return
                }
                else {
                    fatalError("user.complete(mission: missionID)")
                }
                
            }
                
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
            }
//        }

        
    }
    
    
    
    //升级
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"],
            let id = request.parameters["missionid"],
            let missionID = Int(id)
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        let isSucceed = user.upgrade(mission: missionID)

        if isSucceed {
            let m = user.findMission(index: missionID)!
            try response.send(OCTResponse.Succeed(data: m.json)).end()
        }
        else {
            try response.send(OCTResponse.DatabaseError).end()
        }
        
    }
    
    
    
    //删除
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"],
            let id = request.parameters["missionid"],
            let missionID = Int(id)
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        _ = user.remove(mission: missionID)
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
    
}











//
//class MMBaoshiMiddleware: RouterMiddleware {
//    
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let key = request.parameters["key"],
//                let type = request.parameters["type"],
//                let json = request.jsonBody
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        
//        
//        Logger.debug("URL: \(request.matchedPath), Body: \(json)")
//        
//        
//         guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.UserNotExists).end()
//            return
//        }
//
//        if type == "upgrade" {
//            try upgrade(user: user, json: json, response: response, next: next)
//        } else if type == "fillin" {
//            try fillin(user: user, json: json, response: response, next: next)
//        } else if type == "fillout" {
//            try fillout(user: user, json: json, response: response, next: next)
//        } else {
//            try response.send(OCTResponse.InputFormatError).end()
//        }
//        
//        
//        
//
//    }
//    
//    
//    
//    func upgrade(user: MMUser, json: JSON, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let kind = json["kind"].string,
//                let level = json["level"].int,
//                let howMany = json["howmany"].int else {
//        try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        let baoshi = MMBaoshi(key: kind, level: level)
//        
//        
//        do {
//            try user.upgradeBaoshi(toBaoshi: baoshi, ofLevel: level, howMany: howMany)
//            try response.send(OCTResponse.EmptyResult).end()
//        } catch {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        
//    }
//    
//    
//    func fillin(user: MMUser, json: JSON, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let fabaoKey = json["fabao"].string,
//                let baoshiString = json["baoshi"].string else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        guard var fabao = user.findFabao(key: fabaoKey),
//            let baoshi = MMBaoshi.deserialize(fromString: baoshiString)
//            else {
//            try response.send(OCTResponse.InputEmpty).end()
//            return
//        }
//     
//        
//        
//        do {
//            try user.fillin(baoshi: baoshi, inFabao: &fabao)
//        } catch {
//            try response.send(OCTResponse.DatabaseError).end()
//            return
//        }
//        
//        
//        try response.send(OCTResponse.EmptyResult).end()
//        
//    }
//    
//    
//    func fillout(user: MMUser, json: JSON, response: RouterResponse, next: @escaping () -> Void) throws {
//        guard let fabaoKey = json["fabao"].string,
//                let baoshiString = json["baoshi"].string else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        guard var fabao = user.findFabao(key: fabaoKey),
//                let baoshi = KindLevelType.deserialize(fromString: baoshiString)
//        else {
//                try response.send(OCTResponse.InputEmpty).end()
//                return
//        }
//        
//        
//        do {
//            try user.fillout(baoshi: baoshi, inFabao: &fabao)
//        } catch {
//            try response.send(OCTResponse.DatabaseError).end()
//            return
//        }
//        
//        
//        try response.send(OCTResponse.EmptyResult).end()
//    }
//    
//    
//}




//class MMSlotsMiddleware: RouterMiddleware {
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        guard let key = request.parameters["key"],
//                let id = (request.parameters["battleid"]),
//                let battleid = Int(id)
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        
//        if battleid < user.dungeonLevel {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        
//        
//        
//        guard let json = request.jsonBody,
//            let properties = json["properties"].intDictionary,
//            let invs = json["invs"].array
//            else {
//                try response.send(OCTResponse.InputFormatError).end()
//                return
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        for k in properties.keys {
//            if k == kGold {
//                user.gold += properties[k]!
//            } else if k == kYuanBao {
//                user.yuanbao += properties[k]!
//            }
//        }
//        
//        
//        for inv in invs {
//            
//            let category = MMCategory.deserialize(fromString: inv[kCategory].stringValue)
//            
//            switch category {
//            case .weapon:
//                user.add(weapon: MMWeapon.deserialize(fromJSON: inv))
//            case .armor:
//                user.add(armor: MMArmor.deserialize(fromJSON: inv))
//            case .trinket:
//                user.add(trinket: MMTrinket.deserialize(fromJSON: inv))
//            case .misc:
//                user.add(misc: MMMisc.deserialize(fromJSON: inv))
//            }
//
//        }
//        
//        
//        try response.send(OCTResponse.Succeed(data: user.bagJSON)).end()
//        
//        
//    }
//    
//    
//}







