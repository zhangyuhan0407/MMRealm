//
//  MWMailBox.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/21/17.
//
//

import Foundation
import OCTFoundation
import Kitura
import OCTJSON


class MMMailBoxMiddleware: RouterMiddleware {
    
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let method = request.method.rawValue.lowercased()
        
        if method == "get" {
            try get(request: request, response: response, next: next)
        } else if method == "post" {
            try post(request: request, response: response, next: next)
        } else if method == "put" {
            try put(request: request, response: response, next: next)
        } else if method == "delete" {
            try delete(request: request, response: response, next: next)
        } else {
            try response.send(OCTResponse.InputFormatError).end()
        }
        
    }
    
    
    
    
    
    func get(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"],
                let mailKey = request.parameters["mailkey"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        
        if mailKey == "all" {
            let json = user.mailsJSON
            try response.send(OCTResponse.Succeed(data: json)).end()
            return
        }
        else {
            if let mail = user.findMail(key: mailKey) {
                let isSucceed = user.checkMail(mail: mail)
                if isSucceed {
                    try response.send(OCTResponse.Succeed(data: mail.json)).end()
                    return
                }
                else {
                    try response.send(OCTResponse.InputFormatError).end()
                    return
                }
            }
            
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
            }
        }
        
        
    }
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"],
            let mailKey = request.parameters["mailkey"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        let jsons = user.rewardMail(key: mailKey)
        
        if jsons.count == 0 {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        else {
            try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
            return
        }
        
        
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        guard let json = request.jsonBody
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        let mail = ENMail.deserialize(fromJSON: json)
        let isSucceed = user.add(mail: mail)
        if isSucceed {
            try response.send(OCTResponse.Succeed(data: mail.json)).end()
            return
        }
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let key = request.parameters["key"],
            let mailKey = request.parameters["mailkey"]
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        _ = user.deleteMail(key: mailKey)
        
        try response.send(OCTResponse.EmptyResult).end()
        
    }
    

    
    
    
    
    
    
    
}



