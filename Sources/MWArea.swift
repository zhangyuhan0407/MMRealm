//
//  MWArea.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation



class MMAreaMiddleware: RouterMiddleware {
    
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
            let areaKey = request.parameters["area"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        let areaJSON = JSON.read(fromFile: "\(AreaPath)/\(areaKey)")!
        
        let a = MMInvestmentRepo.sharedInstance.findInvestments(keys: areaJSON["investments"].stringArray!)
        var investmentsJSON = [JSON]()
        for aa in a {
            investmentsJSON.append(aa.json)
        }
        
        
        let myarea = user.findArea(key: areaKey)
        
        let dict: [String: Any] = ["area": areaJSON,
                                   "investments": JSON(investmentsJSON),
                                   "displayarea": areaJSON["displayname"].string!,
                                   "myarea": myarea.json]
        
        
        try response.send(OCTResponse.Succeed(data: JSON(dict))).end()
        
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
        
        
        if user.silver < 100 {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        if user.moveToken == 0 {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        _ = user.remove(silver: 100)
        _ = user.remove(moveToken: 1)
        
        let areaKey = json["area"].string!
        
        let isSucceed = user.changeArea(to: areaKey)
        if isSucceed {
            
            let area = ENAreaRepo.sharedInstance.findArea(key: areaKey)
            
            let investmentsJSON = MMInvestmentRepo.sharedInstance.findInvestments(keys: area.investments).map { $0.json }
            
            _ = user.reloadAreaNPC()
            let myarea = user.findArea(key: areaKey)
            
            
            let dict: [String: Any] = ["area": area.json,
                                       "investments": JSON(investmentsJSON),
                                       "myarea": myarea.json,
                                       "silver": user.silver,
                                       "displayarea": user.displayArea,
                                       "movetoken": user.moveToken]
            
            try response.send(OCTResponse.Succeed(data: JSON(dict))).end()
        }
        else {
            try response.send(OCTResponse.DatabaseError).end()
        }
        
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    

}






