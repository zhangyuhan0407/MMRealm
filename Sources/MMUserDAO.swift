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
        let user = MMUser()
        
        
        user.key = key
        
        user.displayName = "雇佣兵"
        
        user.gold = 2000
        
        
        
        
        //Mail
        var mail = ENMail(key: UUID().description)
        mail.sour = "xxxx"
        mail.dest = user.key
        mail.sourDisplayName = "系统邮件"

        mail.title = ""
        mail.info = "..."
        
        mail.rewards = ["PROP_Gold_999"]
        user.add(mail: mail)
        
        return user
    }
    
    
    
    
    
    func load(user key: String) -> MMUser? {
        
        guard let user = loadInfo(forUserKey: key) else {
            return nil
        }
        
        
        //ShopItem
        //Mission
        loadBag(forUser: user)
        loadChars(forUser: user)
        loadMail(forUser: user)
        
        return user
    }
    
    
    func save(_ user: MMUser) throws {
        
        saveInfo(forUser: user)
        saveBag(forUser: user)
        saveChars(forUser: user)
        saveMails(forUser: user)
        
    }
    
    
    
    
    
    //MARK:- Save
    
    
    func saveInfo(forUser user: MMUser) {
        var json = user.infoJSON
        json["shopitems"] = user.shopItemJSON
        json["missions"] = user.missionJSON
        json["dungeons"] = user.dungeonJSON
        json["investments"] = user.investmentsJSON
        json["areas"] = user.areasJSON
        
        do {
            try json.description.write(toFile: "\(UserRepoPath)/\(user.key)", atomically: true, inAppendMode: false)
        } catch {
            fatalError()
        }
    }
    
    
    
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
    
    
    func saveMails(forUser user: MMUser) {
        do {
            try user.mailsJSON.description.write(toFile: "\(UserMailBoxPath)/\(user.key)", atomically: false, inAppendMode: false)
        } catch {
            fatalError()
        }
    }
    
  
    
    
    
    //MARK:- Load
    
    
    
    func loadInfo(forUserKey key: String) -> MMUser? {
        guard let json = JSON.read(fromFile: "\(UserRepoPath)/\(key)") else {
            return nil
        }
        
        let user = MMUser.deserialize(fromJSON: json)
        
        user.shopItems = []
        for itemJSON in json["shopitems"].array! {
            user.shopItems.append(ENShopItem.deserialize(fromJSON: itemJSON))
        }
        
        
        user.missions = []
        let missionArray = json["missions"].array ?? []
        for mm in missionArray {
            user.missions.append(MYMission.deserialize(fromJSON: mm))
        }

        user.dungeons = []
        let dungeonArray = json["dungeons"].array ?? []
        for dd in dungeonArray {
            user.dungeons.append(MYDungeon.deserialize(fromJSON: dd))
        }
        
        
        return user
        
    }
    
    
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
                    let misc = MMMisc.deserialize(fromJSON: json)
                    misc.count = json["count"].int ?? 1
                    temp.append(misc)
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
    
    
    @discardableResult
    func loadMail(forUser user: MMUser) -> Bool {
        let json = JSON.read(fromFile: "\(UserMailBoxPath)/\(user.key)")!
        
        
        var ret = [ENMail]()
        let array = json.array!
        
        for j in array {
            let mail = ENMail.deserialize(fromJSON: j)
            ret.append(mail)
        }
        
        user.mails = ret
        return true
        
    }
    
    
}










