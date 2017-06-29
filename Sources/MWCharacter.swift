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


class MMCharacterMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        let method = request.method.rawValue.lowercased()
        
        
        //读取卡牌
        if method == "get" {
            try get(request: request, response: response, next: next)
        }
            
        //获得卡牌
        else if method == "post" {
            try post(request: request, response: response, next: next)
        }
        
        //保存阵型
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
        
        
        
        var cardKey = json[kCardKey].string!
        
        user.convertKey(key: &cardKey)
        
        Logger.debug(cardKey)
        
        let charJSON = JSON.read(fromFile: "\(CardPath)/\(cardKey)")!
        let card = MMCard.deserialize(fromJSON: charJSON)
        let char = MMCharacter(card: card)
        
        
        let isSucceed = user.add(card: char)
        
        if isSucceed {
            try response.send(OCTResponse.Succeed(data: char.json)).end()
        }
        else {
            try response.send(OCTResponse.Succeed(data: char.json)).end()
        }
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





