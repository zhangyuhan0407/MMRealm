//
//  MMUserManager.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTFoundation

#if os(Linux)
    import Dispatch
#endif

class MMUserManager {
    
    static var sharedInstance = MMUserManager()
    
    private var users: [MMUser]
    
    private var messages: [String: [String]]
    
    
    private init() {
        users = []
        messages = [:]
        
        DispatchQueue.global().async {
            self.looper()
        }
        
    }
    
    
    func timeout(d1: Date, d2: Date) -> Bool {
        if (d2 - 3600) > d1 {
            return true
        }
        
        
        return false
    }
    
    
    func looper() {
        let now = Date()
        for user in self.users {
            if timeout(d1: user.lastLogin, d2: now) {
                debugPrint("\(user.key) ----- TIMEOUT")
                self.destroy(user: user)
            }
        }
        
        sleep(60)
        self.looper()
    }
    
    
    
    func find(key: String) -> MMUser? {
        for user in self.users {
            if user.key == key {
                return user
            }
        }
        
        return nil
    }
    
    
    
    func add(user: MMUser) {
        self.users.append(user)
    }
    
    
    
    func destroy(user: MMUser) {
        save(user: user)
        self.users = self.users.filter { $0.key != user.key }
    }
    
    
    func save(user: MMUser) {
        do {
            try MMUserDAO.sharedInstance.save(user)
        } catch {
            fatalError()
        }
    }
    
    
    
    
    
    //MARK:- Message
    
    
    
    func findMessage(forUser user: String) -> [String] {
        
        var ret = [String]()
        
        for msg in messages {
            if msg.key == user {
                ret = msg.value
                messages.removeValue(forKey: user)
            }
        }
        
        return ret
        
    }
    
    
    func addMessage(forUser user: String, message msg: String) {
        var message = findMessage(forUser: user)
        
        message.append(msg)
        
        messages.updateValue(message, forKey: user)
    }
    
    
    
}










