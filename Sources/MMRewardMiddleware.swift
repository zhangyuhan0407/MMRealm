//
//  MMRewardMiddleware.swift
//  MMRealm
//
//  Created by yuhan zhang on 11/29/16.
//
//

import Foundation
import Kitura

import OCTJSON
import OCTFoundation


class MMRewardMiddleware: RouterMiddleware {
    
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        guard let key = request.parameters["key"] else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        guard let dict = request.jsonBody?.intDictionary else {
            try response.send(OCTResponse.InputFormatError).end()
            return
        }
        
        
        Logger.debug("URL: \(request.matchedPath), Body: \(dict)")
        
        
        guard let user = MMUserManager.sharedInstance.find(key: key) else {
            try response.send(OCTResponse.ShouldLogin).end()
            return
        }
        
        
        
        try user.updateBag(fromDictionary: dict)
        
        try response.send(OCTResponse.EmptyResult).end()
    }
    
}



//class MMStaticFileServer: RouterMiddleware {
//    
//    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
//        
//        guard let file = request.parameters["file"] else {
//            try response.send(OCTResponse.InputFormatError).end()
//            return
//        }
//        
//        let path = request.parsedURL.path
//        
//        print(path)
//        
//        
//        try response.send(fileName: "\(BasePath)/\(file)").end()
//        
//    }
//    
//}














