//
//  MMFabao.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation



///Add



extension MMUser {
    func add(inv: MMInventory) -> Bool {
        switch inv.category {
        case .weapon:
            return add(weapon: inv as! MMWeapon)
        case .armor:
            return add(armor: inv as! MMArmor)
        case .trinket:
            return add(trinket: inv as! MMTrinket)
        case .misc:
            return add(misc: inv as! MMMisc, count: 1)
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
    
    
    func add(misc: MMMisc, count: Int) -> Bool {
        
        if let m = self.find(misc: misc) {
            m.increase(count: count)
            return true
        }
        
        
        if self.miscs.count > 49 {
            return false
        }
        
        
        self.miscs.append(misc)
        return true
    }
    
    
    
    
}




///Remove



extension MMUser {
    
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
    
    func remove(misc: MMMisc, count: Int) -> Bool {
        
        if var m = find(misc: misc) {
            if m.count > misc.count {
                m.decrease(count: count)
                return true
            }
            
            else if m.count == misc.count {
                m.decrease(count: count)
                self.miscs = self.miscs.filter { $0.key != misc.key }
                return true
            }
            
            else {
                return false
            }
        }
        
        
        
        
        return false
    }

}







/// Find



extension MMUser {
    
    
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
    
    
    func find(misc: MMMisc) -> MMMisc? {
        for m in self.miscs {
            if m.key == misc.key {
                return m
            }
        }
        
        return nil
    }

    
}























