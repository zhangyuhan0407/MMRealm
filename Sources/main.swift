

import Foundation

import Kitura

import OCTJSON
import OCTFoundation


let router = Router()



//MARK:- Card



//router.post("/user/:user/card/:card", middleware: MMCharacterMiddleware())




//MARK:- Equipment



router.post("/user/:key/equipment/:type", middleware: MMEquipmentMiddleware())




//MARK:- Chars 



router.get("/user/:key/chars", middleware: MMCharMiddleware())


router.put("/user/:key/chars", middleware: MMCharMiddleware())




//MARK:- Reward


//router.post("", middleware: MMBagMiddleware())

router.post("/user/:key/bag/update", middleware: MMUpdateBagMiddleware())

router.post("/user/:key/bag/:type", middleware: MMBagMiddleware())





//router.post("/user/:key/reward", middleware: MMRewardMiddleware())


router.post("/user/:key/battle/:battleid/slots", middleware: MMSlotsMiddleware())


router.get("/user/:key/message") { (request, response, next) in
    
    guard let key = request.parameters["key"] else {
        try response.send(OCTResponse.InputFormatError).end()
        return
    }
    
    
    let message = MMUserManager.sharedInstance.findMessage(forUser: key)
    
    
    try response.send(JSON(message)).end()
    
    
}




// Fabao



//router.get("/user/:key/fabao", middleware: MMFabaoMiddleware())

///打造法宝
//router.post("/user/:key/fabao/forge", middleware: MMFabaoMiddleware())

///购买法宝
//router.post("/user/:key/fabao/buy") { (request, response, next) in
//    
//    guard let key = request.parameters["key"] else {
//        try response.send(OCTResponse.InputFormatError).end()
//        return
//    }
//    
//    
//    guard let json = request.jsonBody,
//        let fabaoString = json["fabao"].string,
//        let cost = json["cost"].intDictionary
//    else {
//        try response.send(OCTResponse.InputFormatError).end()
//        return
//    }
//    
//    
//    Logger.debug("URL: \(request.matchedPath), Body: \(json)")
//
//    
//    guard let user = MMUserManager.sharedInstance.find(key: key) else {
//        try response.send(OCTResponse.ShouldLogin).end()
//        return
//    }
//    
//    
//    guard let fabao = MMFabao.deserialize(fromString: fabaoString) else {
//        try response.send(OCTResponse.InputFormatError).end()
//        return
//    }
//    
//    
//    do {
//        try user.buyFabao(fabao: fabao, cost: cost)
//        try response.send(OCTResponse.EmptyResult).end()
//    } catch {
//        try response.send(OCTResponse.ServerError).end()        
//    }
//    
//    
//}



//store



//router.get("/user/:key/store", middleware: MMStoreMiddleware())


//router.post("/user/:key/store", middleware: MMStoreMiddleware())



// Baoshi



//router.post("/user/:key/baoshi/:type", middleware: MMBaoshiMiddleware())




router.get("/user/:key/bag") { (request, response, next) in
    
    guard let key = request.parameters["key"] else {
        try response.send(OCTResponse.InputFormatError).end()
        return
    }
    
    
    guard let user = MMUserManager.sharedInstance.find(key: key) else {
        try response.send(OCTResponse.ShouldLogin).end()
        return
    }
    
    
    try response.send(OCTResponse.Succeed(data: user.bagJSON)).end()
    
}



//MARK:- User



router.get("/user/:key", middleware: MMUserMiddleware())


router.post("/user/:key", middleware: MMUserMiddleware())


router.delete("/user/:key", middleware: MMUserMiddleware())





Kitura.addHTTPServer(onPort: 8899, with: router)


Kitura.run()













