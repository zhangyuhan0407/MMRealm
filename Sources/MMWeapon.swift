//
//  MMWeapon.swift
//  MMClient
//
//  Created by yuhan zhang on 5/3/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON


enum MMWeaponType: String {
    
    case ShortBlade
    case Bow
    case Halberd
    case Hammer
    case Mace
    case Axe
    case OneSword
    case Rifle
    case Spear
    case Staff
    case TwoSword
    
    
    var avaliableCharacters: [String] {
        switch self {
        case .ShortBlade:
            return ["dz_cisha", "dz_minrui"]
        case .Bow, .Rifle:
            return ["lr_sheji", "lr_shengcun", "lr_shouwang"]
        case .Halberd:
            return ["zs_kuangbao", "zs_wuqi"]
        case .Hammer:
            return ["qs_chengjie", "zs_wuqi", "zs_kuangbao"]
        case .Mace:
            return ["ms_shensheng", "dz_zhandou", "sm_zengqiang", "sm_yuansu", "sm_zhiliao"]
        case .Axe:
            return ["dz_zhandou"]
        case .OneSword:
            return ["dz_zhandou", "zs_kuangbao"]
        case .Spear:
            return ["xd_mao", "xd_xiong"]
        case .Staff:
            return ["fs_bingshuang", "fs_huoyan", "fs_aoshu",
                    "ms_shensheng", "ms_jielv", "ms_anying",
                    "ss_huimie", "ss_tongku", "ss_emo"]
        case .TwoSword:
            return ["zs_wuqi", "qs_chengjie"]
        }
    }
    
    
    static func deserialize(from s: String) -> MMWeaponType {
        return MMWeaponType(rawValue: s)!
    }
    
    
    
    var displayName: String {
        return self.rawValue
    }
    
    
    static func random() -> MMWeaponType {
        let index = Int.random(max: 11)
        switch index {
        case 0:
            return .ShortBlade
        case 1:
            return .Bow
        case 2:
            return .OneSword
        case 3:
            return .TwoSword
        case 4:
            return .Axe
        case 5:
            return .Halberd
        case 6:
            return .Hammer
        case 7:
            return .Mace
        case 8:
            return .Spear
        case 9:
            return .Rifle
        case 10:
            return .Staff
        default:
            fatalError()
        }
    }
    
    
}



struct MMWeapon: MMInventory {
    
    var key: String = "DEFAULT_KEY"
    var imageName: String = "DEFAULT_IMAGE_NAME"
    var displayName: String = "默认武器"
    var category: MMCategory = .weapon
    var rarity: MMRarity = .white
    var count: Int = 0
    
    var type: MMWeaponType = .Rifle
    
    
    var hp: Int = 0
    var sp: Int = 0
    var atk: Int = 0
    var def: Int = 0
    
    
    var baoji: Int = 0
    var mingzhong: Int = 0
    var shanbi: Int = 0
    var gedang: Int = 0
    
    
    var avaliableCharacters: [String] {
        return self.type.avaliableCharacters
    }
    
    
    init() {
        
    }
    
    
    
    static func deserialize(fromJSON json: JSON) -> MMWeapon {
        
        var ret = MMWeapon()
        
        ret.key = json[kKey].string!
        ret.imageName = json[kImageName].stringValue
        ret.displayName = json[kDisplayeName].stringValue
        ret.category = MMCategory.deserialize(fromString: json[kCategory].stringValue)
        ret.rarity = MMRarity.deserialize(fromString: json[kRarity].stringValue)
        ret.count = json[kCount].intValue
        ret.type = MMWeaponType.deserialize(from: json[kType].stringValue)
        
        
        ret.hp = json[kHP].int ?? 0
        ret.sp = json[kSP].int ?? 0
        ret.atk = json[kATK].int ?? 0
        ret.def = json[kDef].int ?? 0
        ret.baoji = json[kBaoJi].int ?? 0
        ret.mingzhong = json[kMingZhong].int ?? 0
        ret.gedang = json[kGeDang].int ?? 0
        ret.shanbi = json[kShanBi].int ?? 0
        
        
        return ret
    }
    
    
    var dict: [String : Any] {
        return [kKey: self.key,
                kImageName: imageName,
                kDisplayeName: displayName,
                kCategory: category.description,
                kRarity: rarity.description,
                kCount: count,
                kType: self.type.rawValue,
                kHP: self.hp,
                kSP: self.sp,
                kATK: self.atk,
                kDef: self.def,
                kBaoJi: baoji,
                kMingZhong: mingzhong,
                kShanBi: self.shanbi,
                kGeDang: self.gedang
            ] as [String: Any]
    }
    
    
    static func random(level: Int) -> MMWeapon {
        var ret = MMWeapon()
        
        ret.key = NSUUID().description
        
        
        let randomNumber = Int.random()
        var rarity: MMRarity = .white
        if randomNumber < 10 {
            rarity = .purple
        } else if randomNumber < 30 {
            rarity = .blue
        } else if randomNumber < 60 {
            rarity = .green
        }
        ret.rarity = rarity
        ret.type = MMWeaponType.random()
        ret.imageName = "INV_Weapon_\(ret.type.rawValue)_\(level)"
        
        
        return ret
        
    }
    
}




