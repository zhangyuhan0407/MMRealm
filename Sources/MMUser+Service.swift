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
            } else if k == kSilver {
                if self.silver < v as! Int {
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
                    if let misc = find(misc: w) {
                        if misc.count < w.count {
                            return false
                        }
                    }
                    
                    return false
                    
                }
            }
        }
        
        return true
    }
    

    
    
    
    func upgrade(dungeon level: Int) -> Bool {
        self.dungeonLevel = level
        return true
    }
    
    
    
    func has(mission: Int) -> Bool {
        return self.missionLevels.contains(mission)
    }
    
    
    func refreshMission() -> Bool {
        var ret = [Int]()
        while ret.count < 6 {
            let r = Int.random(max: 10) + 1
            
            var isFound = false
            for i in ret {
                if i == r {
                    isFound = true
                    continue
                }
                
            }
            
            if !isFound {
                ret.append(r)
            }
        }
        
        self.missionLevels = ret
        return true
    }
    
    
    
    func remove(mission level: Int) -> Bool {
        if has(mission: level) {
            self.missionLevels = self.missionLevels.filter {
                $0 != level
            }
            return true
        }
        
        return false
    }
    
    
    private func upgrade(mission level: Int) -> Bool {
        
        if !remove(mission: level) {
            return false
        }
        
        
        var exists = false
        
        while !exists {
            let r = Int.random()
            exists = true
            for i in self.missionLevels {
                if i == r {
                    exists = false
                }
            }
        }
        
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
            }
                
            else if k == kSilver {
                self.silver -= v as! Int
            }
            
            else if k == "weapons" {
                for w in v as! [MMWeapon] {
                    self.remove(weapon: w)
                }
            }
            
            else if k == "armors" {
                for w in v as! [MMArmor] {
                    self.remove(armor: w)
                }
            }
            
            else if k == "trinkets" {
                for w in v as! [MMTrinket] {
                    self.remove(trinket: w)
                }
            }
            
            else if k == "miscs" {
                for w in v as! [MMMisc] {
                    self.remove(misc: w, count: w.count)
                }
            }
        }
        
        
        gain.forEach { k, v in
            
            if k == "gold" {
                self.gold += v as! Int
            }
            
            else if k == kSilver {
                self.silver += v as! Int
            }
            
            else if k == "weapons" {
                for w in v as! [MMWeapon] {
                    self.add(weapon: w)
                }
            }
            
            else if k == "armors" {
                for w in v as! [MMArmor] {
                    self.add(armor: w)
                }
            }
            
            else if k == "trinkets" {
                for w in v as! [MMTrinket] {
                    self.add(trinket: w)
                }
            }
            
            else if k == "miscs" {
                for w in v as! [MMMisc] {
                    self.add(misc: w, count: w.count)
                }
            }
            
            
        }
        
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
    
    
    
    func gainSlots(keys: [String]) -> [JSON] {
        
        var ret: [JSON] = []
        
        for j in keys {
            if j.hasPrefix("INV") {
                
                if Int.random() < 10 {
                    
                    let inv = MMInventoryRepo.create(withKey: j)
                    
                    ret.append(inv.json)
                }
                
//                let sub = j.components(separatedBy: "_")
//                
//                let type = sub[1]
//                let level = Int(sub[2])!
//                
//                if type == "Weapon" {
//                    let weapon = MMWeapon.random(level: level)
//                    self.add(weapon: weapon)
//                    ret.append(weapon.json)
//                    continue
//                }
//                    
//                else if type == "Armor" {
//                    let armor = MMArmor.random(level: level)
//                    self.add(armor: armor)
//                    ret.append(armor.json)
//                    continue
//                }
//                    
//                else if type == "Trinket" {
//                    let trinket = MMTrinket.random(level: level)
//                    self.add(trinket: trinket)
//                    ret.append(trinket.json)
//                    continue
//                }
//                    
//                else if type == "Misc" {
//                    let misc = MMMisc.create(fromKey: sub[0] + "_" + sub[1])
//                    self.add(misc: misc, count: level)
//                    ret.append(misc.json)
//                    continue
//                }
//                    
//                else {
//                    fatalError()
//                }
                
                
            }
                
                
                
            else if j.hasPrefix("PROP") {
                
                let sub = j.components(separatedBy: "_")
                let type = sub[1]
                let count = Int(sub[2])!
                
                if type == "Gold" {
                    self.add(gold: count)
                    var gold = MMMisc.create(fromKey: sub[0] + "_" + sub[1])
                    gold.increase(count: count)
                    ret.append(gold.json)
                    continue
                }
                else if type == "Silver" {
                    self.add(silver: count)
                    var silver = MMMisc.create(fromKey: sub[0] + "_" + sub[1])
                    silver.increase(count: count)
                    ret.append(silver.json)
                    continue
                }
                else {
                    fatalError()
                }
                
            }
                
                
                
            else if j.hasPrefix("CARD") {
                
                
                let misc: MMMisc
                if j.contains("Random") {
                    let cls = randomCls()
                    misc = MMMisc.create(fromKey: "CARD_\(cls)")
                }
                else {
                    misc = MMMisc.create(fromKey: j)
                }
                
                
                
                self.add(misc: misc, count: 1)
                ret.append(misc.json)
                continue
            }
                
                
                
            else {
                fatalError()
            }

        }
        
        return ret
    }
    
    
    
    
    
    
    
    
    
    func refreshShopItems() -> Bool {
        self.shopItems = []
        
        for i in 0..<9 {
            
            var item = ShopItem.random()
            item.position = i
            self.shopItems.append(item)
        }
        
        return true
        
    }
    
    
    
    func findItem(item: ShopItem) -> ShopItem? {
        for temp in shopItems {
            if temp.key == item.key {
                return temp
            }
        }
        return nil
    }
    
    
    func remove(shopItem: ShopItem) -> Bool {
        
        if var item = findItem(item: shopItem) {
            if item.count >= shopItem.count {
                item.count -= shopItem.count
                
                if item.count == 0 {
                    self.shopItems = self.shopItems.filter {
                        $0.key != item.key
                    }
                }
                
                return true
            }
        }
        
        return false
    }
    
    
    
    
    
}















