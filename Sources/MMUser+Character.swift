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
    
    
    private func randomTalent(forCls cls: String) -> String {
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
                realKey = "qs_zhiliao"
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

    
    private func charsForKey(key: String) -> [MMCharacter] {
        var ret = [MMCharacter]()
        for char in self.characters {
            if char.key.contains(key) {
                ret.append(char)
            }
        }
        return ret
    }
    
    
    
    func convertKey(key: inout String) -> Bool {
        let chars = charsForKey(key: key)
        
        if let _ = self.findChar(key: key) {
            return false
        }
        
        if key.contains("xd") {
            if chars.count == 4 {
                return false
            }
        }
        else {
            if chars.count == 3 {
                return false
            }
        }
        
        
        var hasTheChar = true
        var newKey = key
        
        while hasTheChar {
            
            if key.contains("CARD") || key.lowercased().contains("random") || key.lowercased().contains("normal") {
                newKey = self.randomTalent(forCls: key.uppercased())
            }
        
            if let _ = self.findChar(key: newKey) {
                hasTheChar = true
            }
            else {
                hasTheChar = false
            }
            
        }
        
        key = newKey
        return true
        
    }
    


    func add(card: MMCharacter) -> Bool {

        if let _ = self.findChar(key: card.key) {
            return false
        }
        
        self.characters.append(card)
        
        return true
        
    }
    
    
    
}


