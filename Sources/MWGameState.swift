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
        
        
//        if user.missionCompleteCount >= user.hightestMissionCount {
//            user.hightestMissionCount = user.missionCompleteCount
//        }

        user.exitGameState()
        
        
        try response.send(OCTResponse.Succeed(data: user.json)).end()
        
        
    }
    
    
    
    
    
}








class MMNPCMiddleware: RouterMiddleware {
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
        
        
        guard let json = request.jsonBody else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        let npc = MYNPC.deserialize(fromJSON: json["npc"])
        //        let name = npc.key
        
        let isSucceed = user.remove(moveToken: 1)
        if !isSucceed {
            try response.send(OCTResponse.UserNotExists).end()
            return
        }
        
        
        let emotion = EmotionType.deserialize(fromString: npc.emotion)
        let result: (String, String)
        switch emotion {
        case .happy:
            result = user.exploreEnemy()
        case .sad:
            result = user.exploreEnemy()
        case .mad:
            result = user.exploreEnemy()
        case .boring:
            result = user.exploreEnemy()
        case .none:
            result = user.exploreEnemy()
        }
        
        let dict: [String: Any] = ["type": result.0,
                                   "key": result.1,
                                   "movetoken": user.moveToken,
                                   "jokes": randomJoke(lineCount: 5),
                                   "npc": npc.json]
        
        
        try response.send(OCTResponse.Succeed(data: JSON(dict))).end()
        
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

















