//
//  MWGameState.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/15/17.
//
//

import Foundation
import OCTFoundation
import OCTJSON
import Kitura


class MMGameStateMiddleware: RouterMiddleware {
    
    
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
        
        user.exitGameState()

        user.enterGameState()
        
        
        let isSucceed = true
        if isSucceed {
            try response.send(OCTResponse.Succeed(data: user.json)).end()
        }
        else {
            try response.send(OCTResponse.ServerError).end()
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
        
        
        if user.missionCompleteCount >= user.hightestMissionCount {
            user.hightestMissionCount = user.missionCompleteCount
        }

        user.exitGameState()
        
        
        try response.send(OCTResponse.Succeed(data: user.json)).end()
        
        
    }
    
    
    
    
    
}
