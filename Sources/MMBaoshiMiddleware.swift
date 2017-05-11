////
////  MMBaoshiMiddleware.swift
////  MMRealm
////
////  Created by yuhan zhang on 1/14/17.
////
////
//
//import Foundation
//import Kitura
//import OCTJSON
//import OCTFoundation
//
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
//
//
//
//
//
//
//
//
