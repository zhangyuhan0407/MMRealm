//
//  MWDisenchant.swift
//  MMRealm
//
//  Created by yuhan zhang on 6/21/17.
//
//

import Foundation
import OCTFoundation
import Kitura
import OCTJSON




class MMDisenchantMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        guard let json = request.jsonBody
            else {
                try response.send(OCTResponse.InputFormatError).end()
                return
        }
        
        
        
        if let invs = json["invs"].array {
            var ret = [JSON]()
            for invJSON in invs {
                let inv = MMInventoryRepo.deserialize(fromJSON: invJSON)
                if let s = user.disenchant(inv: inv) {
                    ret.append(JSON(s))
                }
            }
            try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
            return
        }
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
    }
    
    
}

