//
//  MWExplore.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation
import Kitura
import OCTJSON
import OCTFoundation



class MMExploreMiddleware: RouterMiddleware {
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
        
        guard let key = request.parameters["key"],
            let type = request.parameters["type"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        
        let isSucceed = user.remove(moveToken: 1)
        if !isSucceed {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        
        user.emotion[Int.random(max: 7)] = Int.random()
        user.findArea(key: user.area).reputation += 10
        
        if type == "character" {
            _ = user.remove(silver: 200)
            let result = user.exploreCharacter()
            let ret: [String: Any] = ["type": result.0, "key": result.1, "movetoken": user.moveToken,
                                      "jokes": randomJoke(lineCount: 5)]
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        
        
        else if type == "heriloom" {
            _ = user.remove(silver: 200)
            let result = user.exploreHeriloom()
            let ret: [String: Any] = ["type": result.0, "key": result.1, "movetoken": user.moveToken,
                                      "jokes": randomJoke(lineCount: 5)]
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        
        else if type == "material" {
            _ = user.remove(silver: 200)
            let result = user.exploreMaterial()
            let ret: [String: Any] = ["type": result.0, "key": result.1, "movetoken": user.moveToken,
                                      "jokes": randomJoke(lineCount: 5)]
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        
        else {
            let result = user.explore()
            
            let ret: [String: Any]
            
            switch result.0 {
            case "material":
                ret = ["type": "material", "key": result.1, "movetoken": user.moveToken,
                                            "jokes": randomJoke(lineCount: 4)]
            case "mission":
                ret = ["type": "mission", "key": result.1, "movetoken": user.moveToken,
                                            "jokes": randomJoke(lineCount: 4)]
            case "character":
                ret = ["type": "character", "key": result.1, "movetoken": user.moveToken,
                                            "jokes": randomJoke(lineCount: 4)]
            case "heriloom":
                ret = ["type": "heriloom", "key": result.1, "movetoken": user.moveToken,
                                            "jokes": randomJoke(lineCount: 4)]
            default:
                ret = ["type": "none", "key": "none", "movetoken": user.moveToken,
                                            "jokes": randomJoke(lineCount: 3)]
            }
            
            
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
        }
        
        

        
    }
    
    
    
    func put(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
    func delete(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        try response.send(OCTResponse.InputFormatError).end()
    }
    
    
    
    func randomJoke(lineCount: Int = 3) -> [String] {
        if lineCount == 3 {
            return ["菜鸟玩家",
                    "潜行开锁者",
                    "德鲁伊阿缺"]
        }
        else if lineCount == 4 {
            return ["菜鸟玩家",
                    "卖糖术神",
                    "柔情信仰战",
                    "德鲁伊阿缺"]
        }
        else {
            return ["菜鸟玩家",
                    "卖糖术神",
                    "潜行开锁者",
                    "柔情信仰战",
                    "德鲁伊阿缺"]
        }
        
    }
    
    

}



