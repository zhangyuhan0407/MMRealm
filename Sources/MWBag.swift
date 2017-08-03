//
//  MMRewardMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import Kitura

import OCTJSON
import OCTFoundation


class MMBagMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"],
            let type = request.parameters["type"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(.ShouldLogin).end()
            return
        }
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        let array = json[type].array!
        switch type {
        case "weapon":
            var temp = [MMWeapon]()
            for j in array {
                temp.append(MMWeapon.deserialize(fromJSON: j))
            }
            user.weapons = temp
        case "armor":
            var temp = [MMArmor]()
            for j in array {
                temp.append(MMArmor.deserialize(fromJSON: j))
            }
            user.armors = temp
        case "trinket":
            var temp = [MMTrinket]()
            for j in array {
                temp.append(MMTrinket.deserialize(fromJSON: j))
            }
            user.trinkets = temp
        case "misc":
            var temp = [MMMisc]()
            for j in array {
                temp.append(MMMisc.deserialize(fromJSON: j))
            }
            user.miscs = temp
        default:
            fatalError()
        }
        
        
        
        MMUserDAO.sharedInstance.saveBag(forUser: user)
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
    
    
}




//class MMUpdateBagMiddleware: RouterMiddleware {
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        guard let key = request.parameters["key"]
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(.ShouldLogin).end()
//            return
//        }
//        
//        guard let json = request.jsonBody
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//
//        let gain = MMInventoryRepo.toDictionary(json: json["gain"])
//        let cost = MMInventoryRepo.toDictionary(json: json["cost"])
//        
//        do {
//            try user.updateBag(gain: gain, cost: cost)
//        } catch {
//            fatalError()
//        }
//        
//        try response.send(OCTResponse.EmptyResult).end()
//    }
//    
//}



class MMRewardMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(.ShouldLogin).end()
            return
        }
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        let rewards = json["rewards"].stringArray ?? []
        
        let ret = user.gainSlots(keys: rewards)
        
        try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        
        
    }
    
    
    
    
    
    
    
}








