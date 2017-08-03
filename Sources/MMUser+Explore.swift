//
//  MMUser+Explore.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/19/17.
//
//

import Foundation


enum ExploreType {
    case none           //30
    case material       //30
    case enemyPlayer    //10
    case heriloom       //0.1
    case shop           //5
    case character      //0.1
    case mission        //10
    case dungeon        //10
    case book           //4.8
    
    
    static func random() -> ExploreType {
        
        let random = Int.random(max: 9)
        switch random {
        case 1:
            return .material
        case 2:
            return .enemyPlayer
        case 3:
            return .heriloom
        case 4:
            return .shop
        case 5:
            return .character
        case 6:
            return .mission
        case 7:
            return .none
        case 8:
            return .book
        default:
            return .none
        }
        
    }
    
}



extension MMUser {
    
    
    func exploreMaterial() -> (String, String) {
        let area = ENAreaRepo.sharedInstance.findArea(key: self.area)
        
        if OORandom.happens(inPosibility: 60) {
            return exploreResultMaterial(area: area)
        }
        
        return exploreResultNone(area: area)
    }
    
    
    
    func exploreCharacter() -> (String, String) {
        
        if OORandom.happens(inPosibility: 50) {
            
            let cls = randomCls()
            let talent = randomTalent(forCls: cls)
            if self.has(charKey: talent) {
                return ("none", "none")
            }
            
            return ("character", talent)
        }
        
        return ("none", "none")
    }
    
    
    
    func exploreHeriloom() -> (String, String) {
        let area = ENAreaRepo.sharedInstance.findArea(key: self.area)
        
        if OORandom.happens(inPosibility: 50) {
            return exploreResultHeriloom(area: area)
        }
        
        return exploreResultNone(area: area)
    }
    
    

    func exploreMission() -> (String, String) {

        let index = self.addMission()
        
        return ("mission", "mission_\(index)")
    }
    
    
    func exploreEnemy() -> (String, String) {
        let index = self.addEnemyPlayer()
        
        return ("mission", "mission_\(index)")
    }
    
    
    
    func explore() -> (String, String) {
        let area = ENAreaRepo.sharedInstance.findArea(key: self.area)
        
        let type = ExploreType.random()

        switch type {
        case .material:

            return exploreResultMaterial(area: area)
            
        case .mission:
            
            let result = exploreResultMission(area: area)
            if result.0 == "none" {
                return exploreResultMaterial(area: area)
            }
            else {
                return result
            }
            
        case .character:
            
            let result = exploreResultCharacter(area: area)
            if result.0 == "none" {
                return exploreResultMaterial(area: area)
            }
            else {
                return result
            }
            
        case .heriloom:
            
            let k = area.herilooms.first!
            if self.has(heriloom: k) {
                return exploreResultMaterial(area: area)
            }
            else {
                
                let inv = MMInventoryRepo.create(withKey: k)
                _ = self.add(heriloom: inv)
                
                return ("heriloom", k)
            }
            
        default:
            return ("none", "none")
        }
        
    }
    
    
    
    
    
    private func exploreResultMaterial(area: ENArea) -> (String, String) {
        let key = area.materials.first!
        let count = Int.random(max: 20)
        let k = "\(key)_\(count)"
        
        let inv = MMInventoryRepo.create(withKey: key)
        _ = self.add(misc: inv as! MMMisc, count: count)
        
        
        return ("material", k)
    }
    
    
    
    private func exploreResultCharacter(area: ENArea) -> (String, String) {
        for m in area.characters {
            if !self.has(charKey: m) {
                _ = self.add(card: m)
                return ("character", m)
            }
        }
        
        return ("none", "none")
    }
    
    
    
    private func exploreResultHeriloom(area: ENArea) -> (String, String) {
        for m in area.herilooms {
            if !self.has(heriloom: m) {
                let inv = MMInventoryRepo.create(withKey: m)
                _ = self.add(heriloom: inv)
                return ("heriloom", m)
            }
        }
        return ("none", "none")
    }
    
    
    
    
    
    private func exploreResultMission(area: ENArea) -> (String, String) {
        for m in area.missions {
            let index = Int(m.components(separatedBy: "_").last!)!
            if !has(mission: index) {
                _ = self.addMission(key: m)
                return ("mission", m)
            }
        }
        
        return ("none", "none")
    }
    
    
    
    private func exploreResultNone(area: ENArea) -> (String, String) {
        return ("none", "none")
    }
    
    
    
    
    
    
}













