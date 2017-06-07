//
//  MMCard.swift
//  MMClient
//
//  Created by yuhan zhang on 4/13/17.
//  Copyright © 2017 octopus. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MMCardType {
    case FS
    case MS
    case SS
    case DZ
    case XD
    case LR
    case SM
    case ZS
    case QS
}


func randomCls() -> String {
    let random = Int.random(max: 9)
    let ret: String
    switch random {
    case 0:
        ret = "FS"
    case 1:
        ret = "MS"
    case 2:
        ret = "SS"
    case 3:
        ret = "DZ"
    case 4:
        ret = "XD"
    case 5:
        ret = "SM"
    case 6:
        ret = "LR"
    case 7:
        ret = "ZS"
    case 8:
        ret = "QS"
    default:
        fatalError()
    }
    
    return ret
}



func randomTalent(forCls cls: String) -> String {
    let realKey: String
    let r = Int.random()
    if cls.contains("FS") {
        if r < 33 {
            realKey = "fs_bingshuang"
        } else if r < 66 {
            realKey = "fs_huoyan"
        } else {
            realKey = "fs_aoshu"
        }
    }
    else if cls.contains("SS") {
        if r < 33 {
            realKey = "ss_huimie"
        } else if r < 66 {
            realKey = "ss_emo"
        } else {
            realKey = "ss_tongku"
        }
    }
    else if cls.contains("MS") {
        if r < 33 {
            realKey = "ms_jielv"
        } else if r < 66 {
            realKey = "ms_shensheng"
        } else {
            realKey = "ms_anying"
        }
    }
    else if cls.contains("DZ") {
        if r < 33 {
            realKey = "dz_cisha"
        } else if r < 66 {
            realKey = "dz_minrui"
        } else {
            realKey = "dz_zhandou"
        }
    }
    else if cls.contains("XD") {
        if r < 25 {
            realKey = "xd_mao"
        } else if r < 50 {
            realKey = "xd_xiong"
        } else if r < 75 {
            realKey = "xd_zhiliao"
        } else {
            realKey = "xd_niao"
        }
    }
    else if cls.contains("LR") {
        if r < 33 {
            realKey = "lr_sheji"
        } else if r < 66 {
            realKey = "lr_shengcun"
        } else {
            realKey = "lr_shouwang"
        }
    }
    else if cls.contains("SM") {
        if r < 33 {
            realKey = "sm_yuansu"
        } else if r < 66 {
            realKey = "sm_zengqiang"
        } else {
            realKey = "sm_zhiliao"
        }
    }
    else if cls.contains("ZS") {
        if r < 33 {
            realKey = "zs_wuqi"
        } else if r < 66 {
            realKey = "zs_kuangbao"
        } else {
            realKey = "zs_fangyu"
        }
    }
    else if cls.contains("QS") {
        if r < 33 {
            realKey = "qs_shensheng"
        } else if r < 66 {
            realKey = "qs_chengjie"
        } else {
            realKey = "qs_fangyu"
        }
    }
    else {
        fatalError()
    }
    
    return realKey
}




struct MMCard: JSONDeserializable {
    
    var key: String
    
    var imageName: String
    
    var name: String
    
    var story: String
    
    var skill1Description: String
    
    var skill2Description: String
    
    init(_ key: String) {
        if key == "" {
            fatalError()
        }
        self.key = key
        self.imageName = key
        self.name = key
        self.story = "这是一个\(key)"
        skill1Description = "技能1描述"
        skill2Description = "技能2描述"
    }
    
    
    var dict: [String : Any] {
        return [kKey: key,
                kImageName: imageName,
                kName: name,
                kStory: story,
                kSkill1Description: skill1Description,
                kSkill2Description: skill2Description]
    }
    
    
    static func deserialize(fromJSON json: JSON) -> MMCard {
        let key = json[kKey].stringValue
        var card = MMCard(key)
        card.imageName = json[kImageName].string ?? key
        card.name = json[kName].stringValue
        card.story = json[kStory].string ?? ""
        card.skill1Description = json[kSkill1Description].stringValue
        card.skill2Description = json[kSkill2Description].stringValue
        return card
    }
    
}







