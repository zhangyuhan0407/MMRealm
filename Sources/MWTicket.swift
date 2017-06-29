//
//  OCTDAO.swift
//  SpriteLabServer
//
//  Created by yuhan zhang on 6/28/16.
//
//


import Foundation
import Kitura
import OCTJSON
import OCTFoundation



class MMTicketMiddleware: RouterMiddleware {
    
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
        else if method == "delete" {
            try delete(request: request, response: response, next: next)
        }
        
    }
    
    
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
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
        
        let json = request.jsonBody
        let count = json?["count"].int ?? 1
        let price = json?["price"].int ?? 0
        
        
        
        let isSucceed = user.buyTicket(count: count, gold: price)
        
        
        if isSucceed {
            try response.send(OCTResponse.Succeed(data: JSON(["ticket": user.ticket]))).end()
        }
        else {
            try response.send(OCTResponse.DatabaseError).end()
        }
        
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
     
    }
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        let isSucceed = user.useTicket()
        
        
        if isSucceed {
            try response.send(OCTResponse.Succeed(data: JSON(["ticket": user.ticket]))).end()
        }
        else {
            try response.send(OCTResponse.DatabaseError).end()
        }
        
    }
    
    
    
}


















