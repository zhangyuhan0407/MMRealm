//
//  PGManager.swift
//  OCTMemberServer
//
//  Created by yuhan zhang on 9/19/16.
//
//


import OCTJSON
import OCTFoundation


let MaxMissionCount = 6
let MaxMissionLevel = 11


extension MMUser {
    
    func has(mission: Int) -> Bool {
        
        for m in self.missions {
            if m.index == mission {
                return true
            }
        }
        
        return false
    }
    
    
    func findMission(index: Int) -> MYMission? {
        for m in self.missions {
            if m.index == index {
                return m
            }
        }
        return nil
    }
    
    
    func remove(mission level: Int) -> Bool {
        if has(mission: level) {
            self.missions = self.missions.filter {
                $0.index != level
            }
            return true
        }
        
        return false
    }
    
    
    private func removeAllMission() {
        self.missions = []
    }
    
    
    
    
    
    
    //添加任务
    func addMission() -> Int {
        if self.missions.count >= MaxMissionCount {
            return 0
        }
        
        //MissionIndex
        let missionIndex = Int.random(max: MaxMissionLevel) + 1
        
        if self.has(mission: missionIndex) {
            return addMission()
        }
        
        
        let m = MYMission(key: "mission_\(missionIndex)")
        
        //BossIndex
        
        m.bossIndex = self.maxArmyCount
        m.rewardIndex = 0
        self.missions.append(m)
        
        return missionIndex
        
//        //SlotIndex 
//        //基础奖励
//        var slotIndex = 0
//        
//        
//        //获得卡牌概率计算
//        if self.charMaxCount < self.armyMaxCount {
//            slotIndex += 9000
//        }
//        else if self.charMaxCount < self.armyMaxCount * 2 {
//            if OORandom.happens(inPosibility: 30) {
//                slotIndex += 9000
//            }
//        }
//        else if self.charMaxCount < self.armyMaxCount * 3 {
//            if OORandom.happens(inPosibility: 10) {
//                slotIndex += 9000
//            }
//        }
//        else {
//            if OORandom.happens(inPosibility: 5) {
//                slotIndex += 9000
//            }
//        }
//        
//        //获得卡牌类型计算
//        if slotIndex >= 9000 {
//            slotIndex += Int.random(max: 4) + 1
//        }
//        //未获得卡牌，计算其它奖励
//        else {
//            slotIndex += Int.random(max: 5)
//        }
        
        
//        var level = missionIndex * 1000000 + bossIndex * 10000 + 0
//        
//        self.missionLevels.append(level)
//        
//        return true
        
    }
    
    
    
    func addMission(key: String) -> Int {
        let index = Int(key.components(separatedBy: "_").last!)!
        if self.has(mission: index) {
            return 0
        }
        
        let m = MYMission(key: key)
        self.missions.append(m)
        return index
    }
    
    
    
    //刷新任务
//    func refreshMission() -> Bool {
//        
//        removeAllMission()
//        
//        while self.missionLevels.count < MaxMissionCount {
//            add(mission: 1)
//        }
//        
//        return true
//    }
    
    
    
    
    //完成任务
    func complete(mission level: Int) -> Bool {
        
        if remove(mission: level) {
//            self.missionCompleteCount += 1
            return true
        }
        
        return false
    }
    
    
//    func levelOfMission(_ index: Int) -> Int {
//        
//        let skey = index%10000
//        if skey == 9999 {
//            return 5
//        }
//        else {
//            return "\(skey)".characters.count
//        }
//        
//    }
    
    
    
    //升级任务
    func upgrade(mission index: Int) -> Bool {
        
        guard let m = self.findMission(index: index) else {
            fatalError()
        }
        
        
        if remove(silver: 10) == false {
            return false
        }
        
        
        var skey = m.rewardIndex
        
        let level = m.bossIndex
        
        
        switch level {
        case 1:
            let r = Int.random(max: 3) + 1
            //升级
            if OORandom.happens(inPosibility: 100) {
                skey = 10 + r
            }
            //降级
            else {
                skey = r
            }
        case 2:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 100) {
                skey = 100 + r
            }
            else {
                skey = r
            }
        case 3:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 80) {
                skey = 1000 + r
            }
            else {
                skey = r
            }
        case 4:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 40) {
                skey = 9999
            }
            else {
                skey = r
            }
        case 5:
            return false
        default:
            fatalError()
        }
        
        
        m.bossIndex += 1
        m.rewardIndex = skey
        
        return true
        
    }
    
    
    func addEnemyPlayer() -> Int {
        if self.missions.count >= MaxMissionCount {
            return 0
        }
        
        var index = 0
        if !has(mission: 101) {
            index = 101
        }
        
        
        if !has(mission: 102) {
            index = 102
        }
        
        
        if !has(mission: 103) {
            index = 103
        }
        
        
        if !has(mission: 104) {
            index = 104
        }
        
        
        if !has(mission: 105) {
            index = 105
        }
        
        
        if !has(mission: 106) {
            index = 106
        }
        
        let u = MMUserManager.sharedInstance.randomOnlineUser()
        let m = MYMission(key: "mission_\(index)")
        m.type = "pvp"
        m.enemyUserKey = u.key
        m.enemyUserDisplayName = u.displayName
        
        
        return index
    }
    
    
    
}



















