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
    
    private func checkMaterialsEnough(fromDictionary dict: [String: Any]) -> Bool {
        for k in dict.keys {
            let v = dict[k]
            if k == "gold" {
                if self.gold < v as! Int {
                    return false
                }
            } else if k == "yuanbao" {
                if self.yuanbao < v as! Int {
                    return false
                }
            } else if k == "weapons" {
                for w in v as! [MMWeapon] {
                    if !has(weapon: w) {
                        return false
                    }
                }
            } else if k == "armors" {
                for w in v as! [MMArmor] {
                    if !has(armor: w) {
                        return false
                    }
                }
            } else if k == "trinkets" {
                for w in v as! [MMTrinket] {
                    if !has(trinket: w) {
                        return false
                    }
                }
            } else if k == "miscs" {
                for w in v as! [MMMisc] {
                    if !has(misc: w) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    
    
    
    
//    public func findBag(key: String) -> Int {
//        
////        return self.bag[key] ?? 0
//        
//        return 0
//        
//    }
    
    
    
//    public func findFabao(key: String) -> MMFabao? {
//        
//        for fb in self.fabao {
//            if fb.key == key {
//                return fb
//            }
//        }
//        
//        return nil
//        
//    }
    
    
    
    public func findChar(key: String) -> MMCharacter? {
        
        for c in self.characters {
            if c.card.key == key {
                return c
            }
        }
        
        return nil
        
    }
    
    
    
//    
//    private func add(fabao: MMFabao) throws {
//        
//        //zyh!!  判断是否已经有这个法宝
//        self.fabao.append(fabao)
//        
//    }
//    
    
    
    
    private func add(card: MMCharacter) throws {
        
        //zyh!!
        self.characters.append(card)
    }
    
    
    func has(weapon: MMWeapon) -> Bool {
        for w in self.weapons {
            if w.key == weapon.key {
                return true
            }
        }
        
        return false
    }
    
    func has(armor: MMArmor) -> Bool {
        for w in self.armors {
            if w.key == armor.key {
                return true
            }
        }
        
        return false
    }
    
    func has(trinket: MMTrinket) -> Bool {
        for w in self.trinkets {
            if w.key == trinket.key {
                return true
            }
        }
        
        return false
    }
    
    func has(misc: MMMisc) -> Bool {
        for w in self.miscs {
            if w.key == misc.key {
                return true
            }
        }
        
        return false
    }
    
    
    
    func add(inv: MMInventory) -> Bool {
        switch inv.category {
        case .weapon:
            return add(weapon: inv as! MMWeapon)
        case .armor:
            return add(armor: inv as! MMArmor)
        case .trinket:
            return add(trinket: inv as! MMTrinket)
        case .misc:
            return add(misc: inv as! MMMisc)
        }
    }
    
    
    func add(weapon: MMWeapon) -> Bool {
        if self.weapons.count >= 49 {
            return false
        }
        self.weapons.append(weapon)
        return true
    }
    
    
    func add(armor: MMArmor) -> Bool {
        if self.armors.count >= 49 {
            return false
        }
        self.armors.append(armor)
        return true
    }
    
    
    func add(trinket: MMTrinket) -> Bool {
        if self.trinkets.count >= 49 {
            return false
        }
        self.trinkets.append(trinket)
        return true
    }
    
    
    func add(misc: MMMisc) -> Bool {
        if self.miscs.count >= 49 {
            return false
        }
        self.miscs.append(misc)
        return true
    }
    
    
    func remove(inv: MMInventory) -> Bool {
        switch inv.category {
        case .weapon:
            self.weapons = self.weapons.filter { $0.key != inv.key }
        case .armor:
            self.armors = self.armors.filter { $0.key != inv.key }
        case .trinket:
            self.trinkets = self.trinkets.filter { $0.key != inv.key }
        case .misc:
            self.miscs = self.miscs.filter { $0.key != inv.key }
        }
        
        return true
    }
    
    func remove(weapon: MMWeapon) -> Bool {
        self.weapons = self.weapons.filter { $0.key != weapon.key }
        return true
    }
    
    func remove(armor: MMArmor) -> Bool {
        self.armors = self.armors.filter { $0.key != armor.key }
        return true
    }
    
    func remove(trinket: MMTrinket) -> Bool {
        self.trinkets = self.trinkets.filter { $0.key != trinket.key }
        return true
    }
    
    func remove(misc: MMMisc) -> Bool {
        self.miscs = self.miscs.filter { $0.key != misc.key }
        return true
    }
    
    
    //MARK:- Public
    
    public func updateBag(gain: [String: Any], cost: [String: Any]) throws {
        if !checkMaterialsEnough(fromDictionary: cost) {
            throw OCTError.noMaterial
        }
        
        cost.forEach { k, v in
            if k == "gold" {
                self.gold -= v as! Int
            } else if k == "yuanbao" {
                self.yuanbao -= v as! Int
            } else if k == "weapons" {
                for w in v as! [MMWeapon] {
                    self.remove(weapon: w)
                }
            } else if k == "armors" {
                for w in v as! [MMArmor] {
                    self.remove(armor: w)
                }
            } else if k == "trinkets" {
                for w in v as! [MMTrinket] {
                    self.remove(trinket: w)
                }
            } else if k == "miscs" {
                for w in v as! [MMMisc] {
                    self.remove(misc: w)
                }
            }
        }
        
        
        gain.forEach { k, v in
            if k == "gold" {
                self.gold += v as! Int
            } else if k == "yuanbao" {
                self.yuanbao += v as! Int
            } else if k == "weapons" {
                for w in v as! [MMWeapon] {
                    self.add(weapon: w)
                }
            } else if k == "armors" {
                for w in v as! [MMArmor] {
                    self.add(armor: w)
                }
            } else if k == "trinkets" {
                for w in v as! [MMTrinket] {
                    self.add(trinket: w)
                }
            } else if k == "miscs" {
                for w in v as! [MMMisc] {
                    self.add(misc: w)
                }
            }
        }
        
        
        
    }
    
    
//    public func updateBag(fromDictionary dict: [String: Int]) throws {
//        if !checkMaterialsEnough(fromDictionary: dict) {
//            throw OCTError.noMaterial
//        }
//        
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
//    }
    
    
    public func putCharacters(chars: [MMCharacter]) {
        self.characters = chars
    }
    
    
    
    
    
//    public func fillin(baoshi: MMBaoshi,  inFabao fabao: inout MMFabao) throws {
//        
//        if !self.checkMaterialsEnough(fromDictionary: [baoshi.description: -1]) {
//            throw OCTError.noMaterial
//        }
//        
//        if !fabao.addBaoshi(baoshi: baoshi) {
//            throw OCTError.database
//        }
//        
//        try self.updateBag(fromDictionary: [baoshi.description : -1])
//        
//    }
    
    
    
    
    
//    public func fillout(baoshi: MMBaoshi, inFabao fabao: inout MMFabao) throws {
//        if !fabao.removeBaoshi(baoshi: baoshi) {
//            throw OCTError.database
//        }
//        
//        try self.updateBag(fromDictionary: [baoshi.description : 1])
//    }
    
 
    
    
//    public func upgradeBaoshi(toBaoshi: MMBaoshi, ofLevel level: Int, howMany: Int) throws {
//        if level < 2 {
//            throw OCTError.badInput
//        }
//        
//        let baoshiKey = "\(toBaoshi.key)_\(level - 1)"
//        
////        let count = self.bag[baoshiKey] ?? 0
//        let count = 0
//        
//        if count < howMany * 2 {
//            throw OCTError.badInput
//        }
//        
//        
//        try self.updateBag(fromDictionary: [baoshiKey: -howMany * 2, toBaoshi.description: howMany])
//    }
    

    
    
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
    
//    
//    @discardableResult
//    func updateGold(count: Int) -> Bool {
//        if self.gold + count < 0 {
//            return false
//        }
//        
//        self.gold += count
//        
//        return true
//    }
//    
//    
//    @discardableResult
//    func updateYuanbao(count: Int) -> Bool {
//        if self.yuanbao + count < 0 {
//            return false
//        }
//        
//        self.yuanbao += count
//        
//        return true
//    }

    
    
    
    
//    public func buyFabao(fabao: MMFabao, cost: [String: Int]) throws {
//        
//        try updateBag(fromDictionary: cost)
//        
//        
//        //zyh!! 扣了道具 没得到法宝
//        try add(fabao: fabao)
//        
//    }
//
//    
//    
//    public func buy(item: String, inPrice price: Int, howMany count: Int = 1) -> Bool {
//        if self.gold < price * count {
//            return false
//        }
//        
//        self.gold -= price * count
//        
//        self.addBag(value: count, forKey: item)
//        
//        return true
//    }
    

    
    
    
//    public func makeFabao(fromDict dict: [String: Int]) throws -> MMFabao {
//        
//        try updateBag(fromDictionary: dict)
//        
//        
//        let rarityRandom = Int.random()
//        let rarity: Int
//        
//        if rarityRandom < 50 {
//            rarity = 1
//        } else if rarityRandom < 80 {
//            rarity = 2
//        } else {
//            rarity = 3
//        }
//        
//        
//        let fabao = MMFabao.create(rarity: rarity)
//        
//        try add(fabao: fabao)
//        
//        
//        return fabao
//    }
    
    
    
    
    
//    public func makeCard(card: String, cost: [String: Any]) throws -> MMCard {
//        
//        try updateBag(gain: [:], cost: cost)
//        let ret = MMCard(card)
//        let char = MMCharacter(card)
//        try add(card: char)
//        
//        
//        return ret
//    }

    
    
//
//    public func equip(fabao: MMFabao, forCard card: MMCharacter) throws {
//        if card.fabao != "" {
//            try unequip(fabao: fabao, forCard: card)
//        }
//        
//        card.fabao = fabao.description
//    }
//    
//    
//    
//    public func unequip(fabao: MMFabao, forCard card: MMCharacter) throws {
//        card.fabao = ""
//        try self.add(fabao: fabao)
//    }
    
    
    
}















