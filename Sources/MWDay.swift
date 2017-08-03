//
//  MWDay.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/24/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation




class MMDayMiddleware: RouterMiddleware {
    
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
        try response.send(OCTResponse.InputFormatError).end()
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
        
        
        
        user.nextDay()
        
        let day = user.day
        
        var goldFromSub = 0
        if day % 30 == 0 {
            
            let silver = user.silverForCompony()
            let isSucceed = user.remove(silver: silver)
            if !isSucceed {
                user.exitGameState()
                try response.send(OCTResponse.Succeed(data: user.json)).end()
                return
            }
            
            goldFromSub = user.goldFromSub()
            user.add(gold: goldFromSub)
            
        }
        
        
        _ = user.refreshShopItems()
        
        
        
        if day == 2 || day == 3 || day == 4 {
            _ = user.upgradeBotArmyCount()
        }
        else if day == 7 || day == 8 || day == 9 {
            _ = user.upgradeBotArmyCount()
        }
        
        
        if day % 7 == 0 {
            user.title = user.rankTitle()
        }
        
        
        _ = user.reloadAreaNPC()
        let myarea = user.findArea(key: user.area)
        
        
        
        
        let ret: [String: Any] = ["day": user.day,
                                  "title": user.title,
                                  "silver": user.silver,
                                  "maxmovetoken": user.maxMoveToken,
                                  "maxarmycount": user.maxArmyCount,
                                  "goldfromsub": goldFromSub,
                                  "emotion": user.emotion,
                                  "displaytitle": user.displayTitle,
                                  "myarea": myarea.json,
                                  "shopitems": user.shopItemJSON]
        
        
        try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
}






