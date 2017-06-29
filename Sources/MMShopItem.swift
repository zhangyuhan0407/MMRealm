//
//  MMBaoshi.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation
import OCTJSON


struct ShopItem: JSONDeserializable {
    var key: String
    var price: String
    var count: Int
    var position: Int = 0
    
    var imageName: String = "DEFAULT_IMAGE_NAME"
    var displayName: String = "DEFAULT_DISPLAY_NAME"
    
    
    init(key: String, price: String, count: Int, displayName: String) {
        self.key = key
        self.price = price
        self.count = count
        self.displayName = displayName
        self.imageName = self.key
    }
    
    
    static func deserialize(fromJSON json: JSON) -> ShopItem {
        let key = json[kKey].string!
        let price = json["price"].string!
        let count = json["count"].int ?? 1
        var ret = ShopItem(key: key, price: price, count: count, displayName: json["displayname"].string!)
        
        ret.imageName = json["imagename"].string ?? key

        ret.position = json["position"].int ?? 0
        return ret
    }
    
    var dict: [String : Any] {
        return [kKey: key,
                "price": price,
                "count": count,
                "position": position,
                "imagename": imageName,
                "displayname": displayName
                ]
    }
    
    
    
    
}









