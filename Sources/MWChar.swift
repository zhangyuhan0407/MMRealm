//
//  MMCardMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMCharMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        }
            
        else if method == "post" {
            try post(request: request, response: response, next: next)
        }
        
        else if method == "put" {
            try put(request: request, response: response, next: next)
        }
        
        else {
            next()
        }
        
    }
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        try response.send(OCTResponse.Succeed(data: user.charsJSON)).end()
        
    }
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
    
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
        
        
        
        let cardKey = json[kCardKey].string!
        
        
        let charJSON = JSON.read(fromFile: "\(CardPath)/\(cardKey)")!
        let card = MMCard.deserialize(fromJSON: charJSON)
        let char = MMCharacter(card: card)
        
        user.add(card: char)
        
        try response.send(OCTResponse.Succeed(data: char.json)).end()
        
    }
    
    



    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
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
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(json)")
        
        
        let jsonArray = json[kCharacter].array!
        var chars = [MMCharacter]()
        for json in jsonArray {
            let char = MMCharacter.deserialize(fromJSON: json)
            
            chars.append(char)
        }
        
        
        
        user.putCharacters(chars: chars)
        
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
    
    
    
    
    
    
}



//class MMCharacterMiddleware: RouterMiddleware {
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let key = request.parameters["user"],
//                let card = request.parameters["card"],
//                let cost = request.jsonBody?.intDictionary
//        else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        
//        Logger.debug("URL: \(request.matchedPath), Body: \(cost)")
//        
//        
//        guard let user = MMUserManager.sharedInstance.find(key: key) else {
//            try response.send(OCTResponse.ShouldLogin).end()
//            return
//        }
//        
//        
//        do {
//            let card = try user.makeCard(card: card, cost: cost)
//            try response.send(OCTResponse.Succeed(data: card.json)).end()
//        } catch {
//            try response.send(OCTResponse.ServerError).end()
//            return
//        }
//        
//        
//    }
//}





















