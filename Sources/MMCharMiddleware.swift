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
        } else if method == "put" {
            try put(request: request, response: response, next: next)
        } else {
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
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        guard let jsonArray = request.jsonBody?.array else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(jsonArray)")
        
        
        var chars = [MMCharacter]()
        for json in jsonArray {
            guard let char = MMCharacter.deserialize(fromJSON: json) else {
                try response.send(OCTResponse.InputFormatError).end()
                return
            }
            
            chars.append(char)
        }
        
        
        
        do {
            try user.saveCharacters(chars: chars)
        } catch {
            try response.send(OCTResponse.ServerError).end()
            return
        }
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    
}



class MMCharacterMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["user"],
                let card = request.parameters["card"],
                let cost = request.jsonBody?.intDictionary
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(cost)")
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        do {
            let card = try user.makeCard(card: card, cost: cost)
            try response.send(OCTResponse.Succeed(data: card.json)).end()
        } catch {
            try response.send(OCTResponse.ServerError).end()
            return
        }
        
        
    }
}





















