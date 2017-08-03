//
//  MMStoreMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation



class MMShopMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        } else if method == "post" {
            try post(request: request, response: response, next: next)
        } else if method == "put" {
            try put(request: request, response: response, next: next)
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
        

        try response.send(OCTResponse.Succeed(data: user.shopItemJSON)).end()
        
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
     
        
        
        let itemJSON = json["item"]
        
        
        let item = ENShopItem.deserialize(fromJSON: itemJSON)
        
        if item.key == "PROP_Gold" {
            user.add(gold: item.count)
            try response.send(OCTResponse.EmptyResult).end()
            return
        }
        
        _ = user.remove(shopItem: item)

        let itemKey = item.key
        let price = item.price
        let count = item.count
        
        let p = Int(price.components(separatedBy: "_").last!)!
        
        if price.contains("Gold") {
            user.remove(gold: p)
        } else if price.contains("Silver") {
            user.remove(silver: p)
        } else {
            fatalError()
        }
        
        
        let inv = MMInventoryRepo.create(withKey: itemKey)
        for _ in 0..<count {
            user.add(inv: inv)
        }
        
        
        try response.send(OCTResponse.EmptyResult).end()
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
        
        
        let isSucceed = user.refreshShopItems()
        if isSucceed {
            _ = user.remove(silver: 50)
            try response.send(OCTResponse.Succeed(data: user.shopItemJSON)).end()
        }
        else {
            try response.send(OCTResponse.ServerError).end()
        }
        
        
    }
}











