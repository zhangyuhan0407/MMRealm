

import Foundation
import Kitura
import OCTJSON
import OCTFoundation




let router = Router()



//MARK:- Equipment


router.post("/user/:key/npc", middleware: MMNPCMiddleware())


router.post("/user/:key/equipment/:type", middleware: MMEquipmentMiddleware())




//MARK:- Chars 


//获取卡牌
router.get("/user/:key/chars", middleware: MMCharacterMiddleware())

//保存阵型
router.put("/user/:key/chars", middleware: MMCharacterMiddleware())

//获得卡牌
router.post("/user/:key/chars", middleware: MMCharacterMiddleware())





//MARK:- Reward



//查看背包
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



router.post("/user/:key/reward", middleware: MMRewardMiddleware())




//MARK:- Bag


//保存背包其中某一类型
router.post("/user/:key/bag/:type", middleware: MMBagMiddleware())


//分解物品
router.post("/user/:key/disenchant", middleware: MMDisenchantMiddleware())



//MARK:- Trade


//打造武器
router.post("/user/:key/trade", middleware: MMTradeMiddleware())



//router.post("/user/:key/reward", middleware: MMRewardMiddleware())


//router.post("/user/:key/battle/:battleid/slots", middleware: MMSlotsMiddleware())




//MARK:- Dungeon


//通关地下城
router.post("/user/:key/dungeon/:battleid", middleware: MMDungeonMiddleware())





//MARK:- Mission



//通关任务
router.post("/user/:key/mission/:missionid", middleware: MMMissionMiddleware())

//升级任务
router.put("/user/:key/mission/:missionid", middleware: MMMissionMiddleware())


//Ticket

//购买入场券
router.post("/user/:key/ticket", middleware: MMTicketMiddleware())

//使用入场券
router.post("/user/:key/gamestate", middleware: MMGameStateMiddleware())


router.delete("/user/:key/gamestate", middleware: MMGameStateMiddleware())



//shop


//查看商城
router.get("/user/:key/shop", middleware: MMShopMiddleware())

//购买物品
router.post("/user/:key/shop", middleware: MMShopMiddleware())

//刷新商城
router.put("/user/:key/shop", middleware: MMShopMiddleware())




///MARK:- MailBox


//查看Mail
router.get("/user/:key/mailbox/:mailkey", middleware: MMMailBoxMiddleware())

//获取Mail奖励
router.post("/user/:key/mailbox/:mailkey", middleware: MMMailBoxMiddleware())

//获得Mail奖励
router.put("/user/:key/mailbox/:mailkey", middleware: MMMailBoxMiddleware())

//删除Mail
router.delete("/user/:key/mailbox/:mailkey", middleware: MMMailBoxMiddleware())




///MARK:- Area


router.get("/user/:key/area/:area", middleware: MMAreaMiddleware())

router.post("/user/:key/area", middleware: MMAreaMiddleware())



///MARK:- Explore





router.post("/user/:key/explore/:type", middleware: MMExploreMiddleware())




///MARK:- Day


router.post("/user/:key/day", middleware: MMDayMiddleware())



///MARK:- Investment


router.get("/user/:key/investment", middleware: MMInvestmentMiddleware())

router.post("/user/:key/investment", middleware: MMInvestmentMiddleware())


router.get("/investment/:key") { request, response, next in
    
    guard let key = request.parameters["key"]
        else {
            try response.send(OCTResponse.InputFormatError).end()
            return
    }
    
    
    let keys = key.components(separatedBy: "-")
    
    let a = MMInvestmentRepo.sharedInstance.findInvestments(keys: keys)
    var ret = [JSON]()
    for aa in a {
        var j = aa.json
        ret.append(aa.json)
    }
    
    try response.send(OCTResponse.Succeed(data: JSON(ret))).end()
    
}



//MARK:- User



router.get("/user/:key", middleware: MMUserMiddleware())


router.post("/user/:key", middleware: MMUserMiddleware())


router.delete("/user/:key", middleware: MMUserMiddleware())




#if os(Linux)
    
let myCertFile = "/tmp/Creds/1_maoyiqinwang.com_bundle.crt"
let myKeyFile = "/tmp/Creds/2_maoyiqinwang.com.key"
    
    
let mySSLConfig = SSLConfig(withCACertificateDirectory: "/tmp/Creds/",
                            usingCertificateFile: myCertFile,
                            withKeyFile: myKeyFile,
                            usingSelfSignedCerts: false)
    
    Kitura.addHTTPServer(onPort: 8899, with: router)
#else
    Kitura.addHTTPServer(onPort: 8899, with: router)
#endif


//Kitura.addHTTPServer(onPort: 8899, with: router)


Kitura.run()













