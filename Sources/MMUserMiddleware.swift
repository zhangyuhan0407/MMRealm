//
//  MMUserMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation


class MMUserMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        } else if method == "post" {
            try post(request: request, response: response, next: next)
        } else if method == "delete" {
            try delete(request: request, response: response, next: next)
        } else {
            try response.send(OCTResponse.InputFormatError).end()
        }
        
    }
    
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let key = request.parameters[kKey] ?? "DEFAULT"
        let code = request.queryParameters["code"] ?? "FAKE_CODE"
        
        
        
        //already login
        if let user = MMUserManager.sharedInstance.find(key: key) {
//            try response.send(OCTResponse.UserExists).end()
            try response.send(OCTResponse.Succeed(data: user.json)).end()
            return
        }
        
        
        
        guard let user = MMUserDAO.sharedInstance.findOne(id: key) else {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        
        MMUserManager.sharedInstance.add(user: user)
        
        
        try response.send(OCTResponse.Succeed(data: user.json)).end()
    }
    
    
    
    
    //zyh!!  注册大礼包 数据驱动
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters[kKey] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        if let _ = MMUserDAO.sharedInstance.findOne(id: key) {
            try response.send(OCTResponse.UserExists).end()
            return
        }
        
        
        let newUser = MMUser.create(key: key)
        
        
//        
//        newUser.bag = JSON([:])
//        
        do {
            try MMUserDAO.sharedInstance.save(newUser)
        } catch {
            try response.send(OCTResponse.ServerError).end()
        }
        
        try response.send(newUser).end()
        
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let key = request.parameters[kKey] ?? "DEFAULT"
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.EmptyResult).end()
            return
        }
        
        
        MMUserManager.sharedInstance.destroy(user: user)
        
        try response.send(OCTResponse.EmptyResult).end()
    }
    
    
}














