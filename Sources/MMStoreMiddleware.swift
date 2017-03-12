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


class MMStoreMiddleware: RouterMiddleware {
    
    
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
        
        let dict: [[String: Any]] = [["key": "jinbaoshi", "price": 100, "left": 10],
                                     ["key": "mubaoshi", "price": 100, "left": 10],
                                     ["key": "shuibaoshi", "price": 100, "left": 10],
                                     ["key": "huobaoshi", "price": 100, "left": 10],
                                     ["key": "tubaoshi", "price": 100, "left": 10],
                                     ["key": "tie", "price": 300, "left": 10]]
        
        let json = JSON(dict)
        
        try response.send(json).end()
        
    }
    
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let item = json["item"].string,
            let type = json["type"].string,
            let price = json["price"].int,
            let count = json["count"].int else {
                
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        if type == "fabao" {
//            user
        } else {

            if user.buy(item: item, inPrice: price, howMany: count) {
                try response.send(OCTResponse.EmptyResult).end()
            } else {
                try response.send(OCTResponse.ServerError).end()
            }
        }
        
    }
    
    
}











