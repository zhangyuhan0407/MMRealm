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
                    } else {
                        return false
                    }
                    
                    
                    
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
    
    
    
    //zyh!!
    func gainSlots(keys: [String]) -> [JSON] {
        
        var ret: [JSON] = []
        
        for j in keys {
            if j.hasPrefix("INV_Misc") {
                
                let count = Int(j.components(separatedBy: "_").last!)!
                let k = j.components(separatedBy: "_").dropLast().joined(separator: "_")
                
                var misc = MMInventoryRepo.create(withKey: k)
                misc.count = count
                
                self.add(misc: misc as! MMMisc, count: misc.count)
                ret.append(misc.json)
                
            }
                
                
                
            else if j.hasPrefix("PROP") {
                
                let count = Int(j.components(separatedBy: "_").last!)!
                let k = j.components(separatedBy: "_").dropLast().joined(separator: "_")
                
                
                if k.contains("Gold") {
                    self.add(gold: count)
                    let gold = MMMisc.create(fromKey: k)
                    gold.count = count
                    ret.append(gold.json)
                    continue
                }
                else if k.contains("Silver") {
                    self.add(silver: count)
                    let silver = MMMisc.create(fromKey: k)
                    silver.count = count
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
                var inv = MMInventoryRepo.create(withKey: j)
                inv.count = 1
                self.add(inv: inv)
                ret.append(inv.json)
            }

        }
        
        return ret
    }
    
    
    
    
    
    
    
        
    
    
    
    
}















