//
//  MMUserDAO.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTJSON
import OCTFoundation


class MMUserDAO: OCTDAO {
    
    static var sharedInstance = MMUserDAO()
    
    private init() {}
    
    typealias Model = MMUser
    
    static var TableName: String = "mmuser"
    
    static var PrimaryKey: String = "key"
    
    
    
    func findOne(id: String) -> MMUser? {
        guard let json = JSON.read(fromFile: "\(UserRepoPath)/\(id)") else {
            return nil
        }
        
        
        let dict: [String : Any] = [kKey:       id,
                                    kVIPLevel:  json[kVIPLevel].int ?? 0,
                                    kLevel:     json[kLevel].int ?? 0,
                                    kPVELevel:  json[kPVELevel].int ?? 0,
                                    kPVPLevel:  json[kPVPLevel].int ?? 0,
                                    kGold:      json[kGold].int ?? 0,
                                    kYuanBao:   json[kYuanBao].int ?? 0]
        
        
        let user = MMUser(fromDictionary: dict)
        
        
        loadBag(forUser: user)
        loadChars(forUser: user)
        loadFabao(forUser: user)
        
        
        
        return user
    }
    
    
    
    func save(_ obj: MMUser) throws {
        
        let json = obj.json
        
        try json.description.write(toFile: "\(UserRepoPath)/\(obj.key)", atomically: true, inAppendMode: false)
        
        try saveBag(forUser: obj)
        try saveChars(forUser: obj)
        try saveFabao(forUser: obj)
        
    }
    
    
    
    //MARK:- Save
    
    
    
    func saveBag(forUser user: MMUser) throws {
        
        let jsons = user.bagJSON
        
        try jsons.description.write(toFile: "\(UserBagRepoPath)/\(user.key)", atomically: true, inAppendMode: false)
    }
    
    
    
    func saveChars(forUser user: MMUser) throws {
        
        var jsons = [JSON]()
        
        for c in user.chars {
            jsons.append(c.json)
        }
        
        try JSON(jsons).description.write(toFile: "\(UserCharRepoPath)/\(user.key)", atomically: false, inAppendMode: false)
    }
    
    
    
    func saveFabao(forUser user: MMUser) throws {
        
        var jsons = [JSON]()
        
        for c in user.fabao {
            jsons.append(c.json)
        }
        
        try JSON(jsons).description.write(toFile: "\(UserFabaoRepoPath)/\(user.key)", atomically: false, inAppendMode: false)
        
    }
    
    
    
    //MARK:- Load
    
    
    
    func loadFabao(forUser user: MMUser) -> Bool {
        let s = String.read(fromFile: "\(UserFabaoRepoPath)/\(user.key)") ?? "[]"
        
        do {
            var temp = [MMFabao]()
            
            let json = try JSON.deserialize(s)
            
            let array = json.array!
            
            for fb in array {
                
                if let fabao = MMFabao.deserialize(fromJSON: fb) {
                    temp.append(fabao)
                }
            }
            
            user.fabao = temp
            
        } catch {
            return false
        }
        
        return true
    }
    
    
    
    func loadBag(forUser user: MMUser) -> Bool {
        let s = String.read(fromFile: "\(UserBagRepoPath)/\(user.key)") ?? "{}"
        
        do {
            let json = try JSON.deserialize(s)
            
            let dict = json.intDictionary ?? [:]
            
            user.bag = dict
            
        } catch {
            Logger.error("JSON Format Error: --- \(s)")
            return false
        }
        
        return true
        
    }
    
    
    
    func loadChars(forUser user: MMUser) -> Bool {
        
        let s = String.read(fromFile: "\(UserCharRepoPath)/\(user.key)") ?? "[]"
        
        do {
            var temp = [MMCharacter]()
            
            let json = try JSON.deserialize(s)
            
            let array = json.array!
            
            for char in array {
                
                let card = char["card"].string
                let position = char["position"].int
                let fabao = char["fabao"].string
                
                let c = MMCharacter(card: card!, position: position!, fabao: fabao!)
                
                temp.append(c)
            }
            
            user.chars = temp
            
        } catch {
            return false
        }
        
        return true
    }
    
    
    
}






