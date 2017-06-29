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
        
        let missionIndex = mission/1000000
        for level in self.missionLevels {
            if level/1000000 == missionIndex {
                return true
            }
        }
        
        return false
    }
    
    
    
    private func remove(mission level: Int) -> Bool {
        if has(mission: level) {
            self.missionLevels = self.missionLevels.filter {
                $0 != level
            }
            return true
        }
        
        return false
    }
    
    
    private func removeAllMission() {
        self.missionLevels = []
    }
    
    
    
    
    
    
    //添加任务
    func add(mission: Int) -> Bool {
        if self.missionLevels.count >= MaxMissionCount {
            return false
        }
        
        //MissionIndex
        let missionIndex = Int.random(max: MaxMissionLevel) + 1
        
        if self.has(mission: missionIndex * 1000000) {
            _ = add(mission: 1)
            return false
        }
        
        
        //BossIndex
        let bossIndex = self.armyMaxCount
        
        
        
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
        
        
        var level = missionIndex * 1000000 + bossIndex * 10000 + 0
        
        self.missionLevels.append(level)
        
        return true
        
    }
    
    
    
    
    
    
    
    //刷新任务
    func refreshMission() -> Bool {
        
        removeAllMission()
        
        while self.missionLevels.count < MaxMissionCount {
            add(mission: 1)
        }
        
        return true
    }
    
    
    
    
    //完成任务
    func complete(mission level: Int) -> Bool {
        
        if remove(mission: level) {
            self.missionCompleteCount += 1
            return true
        }
        
        return false
    }
    
    
    func levelOfMission(_ index: Int) -> Int {
        
        let skey = index%10000
        if skey == 9999 {
            return 5
        }
        else {
            return "\(skey)".characters.count
        }
        
    }
    
    
    
    //升级任务
    func upgrade(mission index: Int) -> Int {
        
        if !remove(mission: index) {
            fatalError()
        }
        
        
        let mkey = index/1000000
        let bkey = (index%1000000)/10000
        var skey: Int = 0
        
        let level = levelOfMission(index)
        
        
        switch level {
        case 1:
            let r = Int.random(max: 3) + 1
            //升级
            if OORandom.happens(inPosibility: 80) {
                skey = 10 + r
            }
            //降级
            else {
                skey = r
            }
        case 2:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 60) {
                skey = 100 + r
            }
            else {
                skey = r
            }
        case 3:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 40) {
                skey = 1000 + r
            }
            else {
                skey = r
            }
        case 4:
            let r = Int.random(max: 3) + 1
            if OORandom.happens(inPosibility: 20) {
                skey = 9999
            }
            else {
                skey = r
            }
        case 5:
            return index
        default:
            fatalError()
        }
        
        let m = mkey * 1000000 + bkey * 10000 + skey
        
        self.missionLevels.append(m)
        
        return m
        
    }
    
    
    
    
    
    
}



















