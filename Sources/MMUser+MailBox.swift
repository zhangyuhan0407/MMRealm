//
//  MMUser+MailBox.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/21/17.
//
//

import Foundation
import OCTFoundation


extension MMUser {
    
    private func removeMail(key: String) -> Bool {
        self.mails = self.mails.filter { $0.key != key }
        return true
    }
    
    
    
    func findAllMails() -> [ENMail] {
        return self.mails
    }
    
    
    
    func findMail(key: String) -> ENMail? {
        for mail in self.mails {
            if mail.key == key {
                return mail
            }
        }
        return nil
    }
    
    
    func checkMail(mail: ENMail) -> Bool {
        if var mail = self.findMail(key: key) {
            mail.isChecked = true
            return true
        }
        
        return false
    }
    
    
    @discardableResult
    func add(mail: ENMail) -> Bool {
        if findMail(key: mail.key) != nil {
            return false
        }
        
        self.mails.append(mail)
        return true
    }
    
    
    func rewardMail(key: String) -> [JSON] {
        if let mail = self.findMail(key: key) {
            let slots = mail.rewards
            let jsons = self.gainSlots(keys: slots)
            deleteMail(key: key)
            return jsons
        }
        
        
        return []
    }
    
    
    func deleteMail(key: String) -> Bool {
        return self.removeMail(key: key)
    }
    

}













