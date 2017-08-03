//
//  MMUser+Area.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation



//enum Area: String {
//    
//    case jingjigu
//    case tanalisi
//    case pinjizhidi
//    case dongquangu
//    
//    var index: Int {
//        switch self {
//        case .jingjigu:
//            return 1
//        case .tanalisi:
//            return 2
//        case .pinjizhidi:
//            return 3
//        case .dongquangu:
//            return 4
//        }
//    }
//    
//    
//    static func deserialize(fromString s: String) -> Area {
//        if s == "area_1" {
//            return .jingjigu
//        } else if s == "area_2" {
//            return .tanalisi
//        } else if s == "area_3" {
//            return .pinjizhidi
//        } else {
//            return .dongquangu
//        }
//    }
//    
//}

enum EmotionType: Int {
    case none       = 0
    case happy      = 1
    case sad        = 2
    case mad        = 3
    case boring     = 4
    
    
    static var MaxCount: Int {
        return 5
    }
    
    
    static func deserialize(fromString s: String) -> EmotionType {
        if s == "happy" {
            return .happy
        } else if s == "sad" {
            return .sad
        } else if s == "mad" {
            return .mad
        } else if s == "boring" {
            return .boring
        } else {
            return .none
        }
    }
    
    
    var key: String {
        switch self {
        case .none:
            return "none"
        case .happy:
            return "happy"
        case .sad:
            return "sad"
        case .mad:
            return "mad"
        case .boring:
            return "boring"
        }
    }
    
    
    var displayName: String {
        switch self {
        case .none:
            return ""
        case .happy:
            return "开心的"
        case .sad:
            return "悲伤的"
        case .mad:
            return "生气的"
        case .boring:
            return "无聊的"
        }
    }
    
}



class ENAreaRepo {
    static var sharedInstance = ENAreaRepo()
    
    private var areas = [ENArea]()
    
    
    func findArea(key: String) -> ENArea {
        let json = JSON.read(fromFile: "\(AreaPath)/\(key)")!
        return ENArea.deserialize(fromJSON: json)
    }
}



extension MMUser {
    
    func changeArea(to: String) -> Bool {
        
        if self.area == to {
            return true
        }
        
        self.area = to
        self.displayArea = ENAreaRepo.sharedInstance.findArea(key: to).displayName
        
        return true
        
    }
    
    
    
    func findArea(key: String) -> MYArea {
        for area in self.areas {
            if key == area.key {
                return area
            }
        }
        
        let ret = MYArea()
        ret.key = key
        self.areas.append(ret)
        return ret
    }
    
    
    @discardableResult
    func reloadAreaNPC() -> Bool {
        let myarea = self.findArea(key: self.area)
        let area = ENAreaRepo.sharedInstance.findArea(key: self.area)
        
        myarea.npc = randomNPC(forArea: area, count: 3)
        myarea.npc += randomNPC(count: 2)
        return true
    }
    
    
    
    private func randomNPC(forArea area: ENArea, count: Int) -> [MYNPC] {
        let realCount = min(count, area.npc.count)
        
        let indexs = Int.random(count: realCount, max: area.npc.count - 1)
        
        return indexs.map {
            let key = area.npc[$0]
            var npc = ENNPCRepo.sharedInstance.find(key: key)!
            npc.emotion = randomEmotion().key
            return npc
        }
    }
    
    
    private func randomNPC(count: Int) -> [MYNPC] {
        if count == 0 {
            return []
        }
        
        return ENNPCRepo.sharedInstance.random(count: count).map {
            var ret = $0
            ret.emotion = randomEmotion().key
            return ret
        }
        
    }
    
    
    
    
    private func randomEmotion() -> EmotionType {
        let a = Int.random(max: EmotionType.MaxCount)
        return EmotionType(rawValue: a)!
    }
    
}












