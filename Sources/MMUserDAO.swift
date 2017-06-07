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


class MMUserDAO {
    
    static var sharedInstance = MMUserDAO()
    
    private init() {}
    
    
    //zyh!!  注册大礼包 数据驱动
    func createUser(key: String) -> MMUser {
        return MMUser()
    }
    
    
    func load(user key: String) -> MMUser? {
        
        guard let json = JSON.read(fromFile: "\(UserRepoPath)/\(key)") else {
            return nil
        }

        let user = MMUser.deserialize(fromJSON: json)
        
        user.shopItems = []
        for itemJSON in json["shopitems"].array ?? [] {
            user.shopItems.append(ShopItem.deserialize(fromJSON: itemJSON))
        }
        
        
        loadBag(forUser: user)
        loadChars(forUser: user)
        
        return user
    }
    
    
    func save(_ user: MMUser) throws {
        
        var json = user.infoJSON
        json.update(value: user.shopItemJSON, forKey: "shopitems")
        
        try json.description.write(toFile: "\(UserRepoPath)/\(user.key)", atomically: true, inAppendMode: false)
        
        saveBag(forUser: user)
        saveChars(forUser: user)
        
    }
    
    
    
    //MARK:- Save
    
    
    
    func saveBag(forUser user: MMUser) {
        
        do {
            try user.bagJSON.description.write(toFile: "\(UserBagRepoPath)/\(user.key)", atomically: true, inAppendMode: false)
        } catch let e {
            fatalError("\(e)")
        }
    }
    
    
    
    func saveChars(forUser user: MMUser) {
        
        do {
            try user.charsJSON.description.write(toFile: "\(UserCharRepoPath)/\(user.key)", atomically: false, inAppendMode: false)
        } catch {
            fatalError()
        }
        
    }
    
    
    
//    func saveFabao(forUser user: MMUser) throws {
//        
//        var jsons = [JSON]()
//        
//        for c in user.fabao {
//            jsons.append(c.json)
//        }
//        
//        try JSON(jsons).description.write(toFile: "\(UserFabaoRepoPath)/\(user.key)", atomically: false, inAppendMode: false)
//        
//    }
    
    
    
    //MARK:- Load
    
    
    
//    func loadFabao(forUser user: MMUser) -> Bool {
//        let s = String.read(fromFile: "\(UserFabaoRepoPath)/\(user.key)") ?? "[]"
//        
//        do {
//            var temp = [MMFabao]()
//            
//            let json = try JSON.deserialize(s)
//            
//            let array = json.array!
//            
//            for fb in array {
//                
//                if let fabao = MMFabao.deserialize(fromJSON: fb) {
//                    temp.append(fabao)
//                }
//            }
//            
//            user.fabao = temp
//            
//        } catch {
//            return false
//        }
//        
//        return true
//    }
    
    
    @discardableResult
    func loadBag(forUser user: MMUser) -> Bool {
        
        
        func load(type: String, inJSON json: JSON, forUser user: MMUser) {
            let jsonArray = json[type].array ?? []
    
            
    
            switch type {
            case "weapon":
                var temp = [MMWeapon]()
                for json in jsonArray {
                    temp.append(MMWeapon.deserialize(fromJSON: json))
                }
                user.weapons = temp
            case "armor":
                var temp = [MMArmor]()
                for json in jsonArray {
                    temp.append(MMArmor.deserialize(fromJSON: json))
                }
                user.armors = temp
            case "trinket":
                var temp = [MMTrinket]()
                for json in jsonArray {
                    temp.append(MMTrinket.deserialize(fromJSON: json))
                }
                user.trinkets = temp
            case "misc":
                var temp = [MMMisc]()
                for json in jsonArray {
                    temp.append(MMMisc.deserialize(fromJSON: json))
                }
                user.miscs = temp
            default:
                fatalError()
            }
        }
        
        
        
        let s = String.read(fromFile: "\(UserBagRepoPath)/\(user.key)") ?? "{}"
        
        do {
            let json = try JSON.deserialize(s)
            
            
            load(type: "weapon", inJSON: json, forUser: user)
            load(type: "armor", inJSON: json, forUser: user)
            load(type: "trinket", inJSON: json, forUser: user)
            load(type: "misc", inJSON: json, forUser: user)
            
        } catch {
            Logger.error("JSON Format Error: --- \(s)")
            fatalError()
            return false
        }
        
        return true
        
    }
    
    
    @discardableResult
    func loadChars(forUser user: MMUser) -> Bool {
        
        let json = JSON.read(fromFile: "\(UserCharRepoPath)/\(user.key)")!
        
        var temp = [MMCharacter]()
        let array = json.array!
        
        for char in array {
            
            let c = MMCharacter.deserialize(fromJSON: char)
            
            temp.append(c)
        }
        
        user.characters = temp
        
        
        return true
    }
    
    
    
}






