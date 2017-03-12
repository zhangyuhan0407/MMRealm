//
//  MMUser+Service.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation


extension MMUser {
    
    private func checkMaterialsEnough(fromDictionary dict: [String: Int]) -> Bool {
        for (k, v) in dict {
            if k == kGold {
                if self.gold + v < 0 {
                    return false
                }
            } else if k == kYuanBao {
                if self.yuanbao + v < 0 {
                    return false
                }
            } else {
                
                let count = self.bag[k] ?? 0
                
                if count + v < 0 {
                    return false
                }
                
            }
        }
        
        return true
    }
    
    
    
    
    
    
    
    
    
    private func addBag(value v: Int, forKey key: String) {
        let count = self.bag[key] ?? 0
        
        self.bag.updateValue(v + count, forKey: key)
        
    }
   
    
    
    
    
    
//    @discardableResult
//    func reward(fromJSON json: JSON) -> Bool {
//        
//        let dict = json.intDictionary ?? [:]
//        
//        for (k, v) in dict {
//            if k == kGold {
//                self.gold += v
//            } else if k == kYuanBao {
//                self.yuanbao += v
//            } else {
//                self.addBag(value: v, forKey: k)
//            }
//        }
//        
//        return true
//        
//    }
    
    
    
    public func findBag(key: String) -> Int {
        
        return self.bag[key] ?? 0
        
    }
    
    
    
    public func findFabao(key: String) -> MMFabao? {
        
        for fb in self.fabao {
            if fb.key == key {
                return fb
            }
        }
        
        return nil
        
        
    }
    
    
    
    public func findChar(key: String) -> MMCharacter? {
        
        for c in self.chars {
            if c.card == key {
                return c
            }
        }
        
        return nil
        
    }
    
    
    
    
    private func add(fabao: MMFabao) throws {
        
        //zyh!!  判断是否已经有这个法宝
        self.fabao.append(fabao)
        
    }
    
    
    
    
    private func add(card: MMCharacter) throws {
        
        //zyh!!
        self.chars.append(card)
    }
    
    
    
    
    //MARK:- Public
    
    
    
    public func updateBag(fromDictionary dict: [String: Int]) throws {
        if !checkMaterialsEnough(fromDictionary: dict) {
            throw OCTError.noMaterial
        }
        
        
        for (k, v) in dict {
            if k == kGold {
                self.gold += v
            } else if k == kYuanBao {
                self.yuanbao += v
            } else {
                self.addBag(value: v, forKey: k)
            }
        }
        
    }
    
    
    public func saveCharacters(chars: [MMCharacter]) throws {
        self.chars = chars
    }
    
    
    
    
    
    public func fillin(baoshi: MMBaoshi,  inFabao fabao: inout MMFabao) throws {
        
        if !self.checkMaterialsEnough(fromDictionary: [baoshi.description: -1]) {
            throw OCTError.noMaterial
        }
        
        if !fabao.addBaoshi(baoshi: baoshi) {
            throw OCTError.database
        }
        
        try self.updateBag(fromDictionary: [baoshi.description : -1])
        
    }
    
    
    
    
    
    public func fillout(baoshi: MMBaoshi, inFabao fabao: inout MMFabao) throws {
        if !fabao.removeBaoshi(baoshi: baoshi) {
            throw OCTError.database
        }
        
        try self.updateBag(fromDictionary: [baoshi.description : 1])
    }
    
 
    
    
    public func upgradeBaoshi(toBaoshi: MMBaoshi, ofLevel level: Int, howMany: Int) throws {
        if level < 2 {
            throw OCTError.badInput
        }
        
        let baoshiKey = "\(toBaoshi.key)_\(level - 1)"
        
        let count = self.bag[baoshiKey] ?? 0
        
        if count < howMany * 2 {
            throw OCTError.badInput
        }
        
        
        try self.updateBag(fromDictionary: [baoshiKey: -howMany * 2, toBaoshi.description: howMany])
    }
    

    
    
//    @discardableResult
//    func updateBag(name: String, count: Int) -> Bool {
//        
//        let own = self.bag[name] ?? 0
//        
//        if own + count < 0 {
//            return false
//        }
//        
//        self.addBag(value: count, forKey: name)
//        
//        return true
//        
//    }
    
    
    @discardableResult
    func updateGold(count: Int) -> Bool {
        if self.gold + count < 0 {
            return false
        }
        
        self.gold += count
        
        return true
    }
    
    
    @discardableResult
    func updateYuanbao(count: Int) -> Bool {
        if self.yuanbao + count < 0 {
            return false
        }
        
        self.yuanbao += count
        
        return true
    }

    
    
    
    
    public func buyFabao(fabao: MMFabao, cost: [String: Int]) throws {
        
        try updateBag(fromDictionary: cost)
        
        
        //zyh!! 扣了道具 没得到法宝
        try add(fabao: fabao)
        
    }

    
    
    public func buy(item: String, inPrice price: Int, howMany count: Int = 1) -> Bool {
        if self.gold < price * count {
            return false
        }
        
        self.gold -= price * count
        
        self.addBag(value: count, forKey: item)
        
        return true
    }
    

    
    
    
    public func makeFabao(fromDict dict: [String: Int]) throws -> MMFabao {
        
        try updateBag(fromDictionary: dict)
        
        
        let rarityRandom = Int.random()
        let rarity: Int
        
        if rarityRandom < 50 {
            rarity = 1
        } else if rarityRandom < 80 {
            rarity = 2
        } else {
            rarity = 3
        }
        
        
        let fabao = MMFabao.create(rarity: rarity)
        
        try add(fabao: fabao)
        
        
        return fabao
    }
    
    
    
    
    
    public func makeCard(card: String, cost: [String: Int]) throws -> MMCard {
        
        try updateBag(fromDictionary: cost)
        try add(card: MMCharacter(card: card, position: 0, fabao: ""))
        
        
        return MMCard(key: card)
    }
    
    
    
    
    public func equip(fabao: MMFabao, forCard card: MMCharacter) throws {
        if card.fabao != "" {
            try unequip(fabao: fabao, forCard: card)
        }
        
        card.fabao = fabao.description
    }
    
    
    
    public func unequip(fabao: MMFabao, forCard card: MMCharacter) throws {
        card.fabao = ""
        try self.add(fabao: fabao)
    }
    
    
    
}















