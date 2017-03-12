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


class MMFabaoMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        } else if method == "post" {
            try post(request: request, response: response, next: next)
        } else {
            try response.send(OCTResponse.InputFormatError).end()
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
        
        try response.send(OCTResponse.Succeed(data: user.fabaoJSON)).end()
        
    }
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let dict = request.jsonBody?.intDictionary
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(dict)")
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        do {
            
            let fabao = try user.makeFabao(fromDict: dict)
            
            try response.send(OCTResponse.Succeed(data: fabao.json)).end()
            
        } catch {
            try response.send(OCTResponse.DatabaseError).end()
            return
        }
        
        
    }
    
    
}




class MMEquipmentMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let userKey = request.parameters["key"],
                let type = request.parameters["type"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let json = request.jsonBody,
                let fabaoString = json["fabao"].string,
                let cardString = json["card"].string
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(json)")
        
        
        guard let user = MMUserManager.sharedInstance.find(key: userKey) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        guard let fabao = user.findFabao(key: fabaoString),
                let card = user.findChar(key: cardString)
        else {
            try response.send(OCTResponse.DatabaseError).end()
            return
        }
        
        
        do {
            if type == "equip" {
                try user.equip(fabao: fabao, forCard: card)
            } else if type == "unequip" {
                try user.unequip(fabao: fabao, forCard: card)
            } else {
                try response.send(OCTResponse.InputFormatError).end()
                return
            }
        } catch {
            try response.send(OCTResponse.ServerError).end()
        }
        
    }
    
}














