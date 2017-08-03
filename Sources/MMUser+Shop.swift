//
//  MMUser+Shop.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/15/17.
//
//

import Foundation
import OCTFoundation



extension MMUser {
    
    func refreshShopItems() -> Bool {
        self.shopItems = []
        
        for i in 0..<9 {
            
            var item = ENShopItem.random()
            item.position = i
            self.shopItems.append(item)
        }
        
        return true
        
    }
    
    
    
    func findShopItem(item: ENShopItem) -> ENShopItem? {
        for temp in shopItems {
            if temp.position == item.position {
                return temp
            }
        }
        return nil
    }
    
    
    
    func remove(shopItem: ENShopItem) -> Bool {
        
        self.shopItems = self.shopItems.map {
            
            if $0.position == shopItem.position {
                var temp = $0
                temp.count -= shopItem.count
                return temp
            }
            else {
                return $0
            }
            
        }
        
        return true
        
    }
    
    
    
    
    
    
}



extension ENShopItem {
    
    static func random() -> ENShopItem {
        
        
        let r: Int
        //isCard
        if OORandom.happens(inPosibility: 15) {
            r = Int.random(max: 9) + 101
        }
        else {
            r = Int.random(max: 19) + 1
        }
        
        let json = JSON.read(fromFile: "\(ShopItemPath)/shopitem_\(r)")!
        
        let shopItem = ENShopItem.deserialize(fromJSON: json)
        
        return shopItem

    }
    
    
}








