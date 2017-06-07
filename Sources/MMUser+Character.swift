//
//  MMFabao+Service.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation


extension MMUser {
    
    
    public func putCharacters(chars: [MMCharacter]) -> Bool {
        self.characters = chars
        return true
    }
    
    
    
    public func findChar(key: String) -> MMCharacter? {
        
        for c in self.characters {
            if c.card.key == key {
                return c
            }
        }
        
        return nil
        
    }



    func add(card: MMCharacter) -> Bool {

        //zyh!!
        self.characters.append(card)
        
        
        
        return true
        
    }
    
    
    
}





//class MMInventoryRepo {
//    
//    static var sharedInstance = MMInventoryRepo()
//    
//    
//    init() {}
//    
//    
//    func create(key: String, category: String, rarity: String?) -> MMWeapon {
//        
//        let cate = MMCategory.deserialize(fromString: category)
//        
//        let rar: MMRarity
//        if let r = rarity {
//            rar = MMRarity.deserialize(fromString: r)
//        } else {
//            rar = MMRarity.white
//        }
//        
//        
//        let ret = MMWeapon(key: key, category: cate, rarity: rar)
//        
//        
//        
//        return ret
//    }
//    
//    
//}


//
//extension MMFabao {
//    
//    mutating func addBaoshi(baoshi: MMBaoshi) -> Bool {
//        if self.baoshi.count < baoshiCount {
//            self.baoshi.append(baoshi)
//            return true
//        }
//        
//        return false
//    }
//    
//    mutating func removeBaoshi(baoshi: MMBaoshi) -> Bool {
//        var removedIndex = -1
//        
//        for i in 0..<self.baoshi.count {
//            if self.baoshi[i] == baoshi {
//                removedIndex = i
//                break
//            }
//        }
//        
//        if removedIndex < 0 {
//            return false
//        }
//        
//        self.baoshi.remove(at: removedIndex)
//        
//        return true
//        
//    }
//    
//}
