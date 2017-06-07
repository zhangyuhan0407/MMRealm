//
//  MMFabao.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation


//struct MMFabao: CustomStringConvertible {
//    
//    
//    let key: String
//    
//    var baoshiCount: Int = 3
//    
//    var baoshi: [MMBaoshi]
//    
//    
//    var prop1: String = ""
//    var prop2: String = ""
//    var prop3: String = ""
//    var skill: String?
//    
//    
//    init(key: String = UUID.init().description) {
//        self.key = key
//        self.baoshi = []
//    }
//    
//    
//    
//    
//    var json: JSON {
//        var json = JSON(["key": key,
//                         "prop1": prop1,
//                         "prop2": prop2,
//                         "prop3": prop3,
//                         "baoshicount": baoshiCount])
//
//        
//        json["baoshi"] = JSON(baoshi.map { JSON($0.description) })
//        
//        
//        json["skill"] = JSON(skill ?? "")
//        
//        
//        return json
//    }
//    
//    
//    var description: String {
//        return json.description
//    }
//    
//    
//    
//}
//
//
//extension MMFabao {
//    
//    static func deserialize(fromJSON json: JSON) -> MMFabao? {
//        
//        guard let key = json["key"].string,
//            let prop1 = json["prop1"].string,
//            let prop2 = json["prop2"].string,
//            let prop3 = json["prop3"].string,
//            let baoshiCount = json["baoshicount"].int,
//            let baoshiArray = json["baoshi"].stringArray
//        else {
//            return nil
//        }
//        
//        
//        var fabao = MMFabao(key: key)
//        fabao.baoshiCount = baoshiCount
//        fabao.prop1 = prop1
//        fabao.prop2 = prop2
//        fabao.prop3 = prop3
//        fabao.baoshi = []
//        
//        for bs in baoshiArray {
//            if let baoshi = MMBaoshi.deserialize(fromString: bs) {
//                fabao.baoshi.append(baoshi)
//            }
//        }
//        
//        
//        fabao.skill = json["skill"].string
//        
//        return fabao
//    }
//
//    
//    
//    static func deserialize(fromString s: String) -> MMFabao? {
//        do {
//            
//            let json = try JSON.deserialize(s)
//            
//            return deserialize(fromJSON: json)
//            
//        } catch {
//            return nil
//        }
//    }
//    
//    
//    
//    static func create(rarity: Int) -> MMFabao {
//        
//        func createProp(maxValue: Int) -> KindLevelType {
//            let ranKey = Int.random() / 12
//            let key: String
//            switch ranKey {
//            case 1:
//                key = "baoji"
//            case 2:
//                key = "shanbi"
//            case 3:
//                key = "mingzhong"
//            case 4:
//                key = "gedang"
//            case 5:
//                key = "zaisheng"
//            case 6:
//                key = "xixue"
//            case 7:
//                key = "fantanwuli"
//            default:
//                key = "fantanfashu"
//            }
//            
//            
//            let ranLevel = Int.random() % maxValue
//            
//            
//            return KindLevelType(key: key, level: ranLevel)
//        }
//        
//        
//        
//        
//        let baoshiCount: Int
//        let propMaxValue: Int
//        
//        switch rarity {
//        case 1:
//            baoshiCount = 3
//            propMaxValue = 10
//        case 2:
//            baoshiCount = 4
//            propMaxValue = 20
//        case 3:
//            baoshiCount = 5
//            propMaxValue = 30
//        default:
//            baoshiCount = 5
//            propMaxValue = 40
//        }
//        
//        var fabao = MMFabao()
//        
//        fabao.baoshiCount = baoshiCount
//        fabao.prop1 = createProp(maxValue: propMaxValue).description
//        fabao.prop2 = createProp(maxValue: propMaxValue).description
//        fabao.prop3 = createProp(maxValue: propMaxValue).description
//        
//        
//        return fabao
//    }
//    
//    
//}
//
//
//



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
        
        if var m = self.find(misc: misc) {
            m.increase(count: count)
            return true
        }
        
        
        if self.miscs.count >= 49 {
            return false
        }
        
        
        self.miscs.append(misc)
        return true
    }
    
    
    
    func add(gold: Int) -> Bool {
        self.gold += gold
        return true
    }
    
    
    func remove(gold: Int) -> Bool {
        self.gold -= gold
        return true
    }
    
    
    func add(silver: Int) -> Bool {
        self.silver += silver
        return true
    }
    

    func remove(silver: Int) -> Bool {
        self.silver -= silver
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























