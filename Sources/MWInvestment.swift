//
//  MWInvestment.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/27/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation




class MMInvestmentMiddleware: RouterMiddleware {
    
    
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
        guard let key = request.parameters["key"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        let investments = MMInvestmentRepo.sharedInstance.investment(forUser: user.key)
        
        var jsons = [JSON]()
        for investment in investments {
            jsons.append(investment.json)
        }
        
        
        try response.send(OCTResponse.Succeed(data: JSON(jsons))).end()
    }
    
    
    
    func post(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"]
            else {
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
        
        
        if user.title < 2 {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        
        let investKey = json["key"].string!
        for investment in MMInvestmentRepo.sharedInstance.investments {
            if investment.key == investKey {
                var v = 0
                for userKey in investment.investors.keys {
                    if userKey == user.key {
                        v = investment.investors[userKey]!
                        break
                    }
                }
                
                investment.investors.updateValue(v + 1, forKey: user.key)
            }
        }
        
        
        let a = MMInvestmentRepo.sharedInstance.findInvestment(key: investKey)!
        try response.send(OCTResponse.Succeed(data: a.json)).end()
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
}












