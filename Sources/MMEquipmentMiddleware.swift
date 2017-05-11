//
//  MMFabaoMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMEquipmentMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let type = request.parameters["type"]!
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }

        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        let category = MMCategory.deserialize(fromString: json["inv"]["category"].stringValue)
        let char = user.findChar(key: json[kCharacterKey].stringValue)!
        
        
        if type == "equip" {
            equip(user: user, char: char, category: category, json: json)
        } else if type == "unequip" {
            unequip(user: user, char: char, category: category, json: json)
        } else {
            fatalError()
        }
        
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
    
    
    func equip(user: MMUser, char: MMCharacter, category: MMCategory, json: JSON) {
        switch category {
        case .weapon:
            let weapon = MMWeapon.deserialize(fromJSON: json["inv"])
            _ = user.remove(weapon: weapon)
            let existing = char.weapon
            char.weapon = weapon
            if existing != nil {
                _ = user.add(weapon: existing!)
            }
        case .armor:
            let armor = MMArmor.deserialize(fromJSON: json["inv"])
            _ = user.remove(armor: armor)
            let existing = char.armor
            char.armor = armor
            if existing != nil {
                _ = user.add(armor: existing!)
            }
        case .trinket:
            let trinket = MMTrinket.deserialize(fromJSON: json["inv"])
            _ = user.remove(trinket: trinket)
            let existing = char.trinket
            char.trinket = trinket
            if existing != nil {
                _ = user.add(trinket: existing!)
            }
        default:
            fatalError()
        }
    }
    
    
    func unequip(user: MMUser, char: MMCharacter, category: MMCategory, json: JSON) {
        switch category {
        case .weapon:
            let existing = char.weapon
            char.weapon = nil
            if existing != nil {
                _ = user.add(weapon: existing!)
            }
        case .armor:
            let existing = char.armor
            char.armor = nil
            if existing != nil {
                _ = user.add(armor: existing!)
            }
        case .trinket:
            let existing = char.trinket
            char.trinket = nil
            if existing != nil {
                _ = user.add(trinket: existing!)
            }
        default:
            fatalError()
        }
    }
    
    
    
    
    
}




//class MMFabaoMiddleware: RouterMiddleware {
//    
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        let method = request.method.rawValue.lowercased()
//        
//        if method == "get" {
//            try get(request: request, response: response, next: next)
//        } else if method == "post" {
//            try post(request: request, response: response, next: next)
//        } else {
//            try response.send(OCTResponse.InputFormatError).end()
//        }
//        
//    }
//    
//    
//    
//    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//    
//        guard let key = request.parameters["key"] else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        try response.send(OCTResponse.Succeed(data: user.fabaoJSON)).end()
//        
//    }
//    
//    
//    
//    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        guard let key = request.parameters["key"] else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        guard let dict = request.jsonBody?.intDictionary
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        Logger.debug("URL: \(request.matchedPath), Body: \(dict)")
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        do {
//            
//            let fabao = try user.makeFabao(fromDict: dict)
//            
//            try response.send(OCTResponse.Succeed(data: fabao.json)).end()
//            
//        } catch {
//            try response.send(OCTResponse.DatabaseError).end()
//            return
//        }
//        
//        
//    }
//    
//    
//}
//
//
//
//
//class MMEquipmentMiddleware: RouterMiddleware {
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let userKey = request.parameters["key"],
//                let type = request.parameters["type"]
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        guard let json = request.jsonBody,
//                let fabaoString = json["fabao"].string,
//                let cardString = json["card"].string
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        Logger.debug("URL: \(request.matchedPath), Body: \(json)")
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: userKey) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        
//        guard let fabao = user.findFabao(key: fabaoString),
//                let card = user.findChar(key: cardString)
//        else {
//            try response.send(OCTResponse.DatabaseError).end()
//            return
//        }
//        
//        
//        do {
//            if type == "equip" {
//                try user.equip(fabao: fabao, forCard: card)
//            } else if type == "unequip" {
//                try user.unequip(fabao: fabao, forCard: card)
//            } else {
//                try response.send(OCTResponse.InputFormatError).end()
//                return
//            }
//        } catch {
//            try response.send(OCTResponse.ServerError).end()
//        }
//        
//    }
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
//
//
//
//
//
//
