//
//  ENInvestment.swift
//  MMRealm
//
//  Created by yuhan zhang on 7/27/17.
//
//

import Foundation
import OCTJSON


final class ENInvestment: JSONDeserializable {
    
    let data: JSON
    var investors: [String: Int] = [:]
    
    var key: String {
        return data["key"].string!
    }
    
    var displayName: String {
        return data["displayname"].string!
    }
    
    var id: Int {
        return data["id"].int!
    }
    
    
    var imageName: String {
        return data["imagename"].string!
    }
    
    var type: String {
        return data["type"].string!
    }
    
    var inv: MMInventory {
        return MMInventoryRepo.create(withKey: data["inv"].string!)
    }
    
    var price: String {
        return data["price"].string!
    }
    var usage: String {
        return data["usage"].string!
    }
    var story: String {
        return data["story"].string!
    }
    
    
    
    var progress: Int {
        var ret = 0
        for (_, v) in self.investors {
            ret += v
        }
        return ret
    }
    
    
    init(data: JSON) {
        self.data = data
    }
    
    
    static func deserialize(fromJSON json: JSON) -> ENInvestment {
        
        let key = json["key"].string!
        let data = JSON.read(fromFile: "\(InvestmentPath)/\(key)")!
        
        let ret = ENInvestment(data: data)
        ret.investors = json["investors"].intDictionary ?? [:]
        
        return ret
    }
    
    var dict: [String : Any] {
        return ["key": key,
                "investors": investors]
    }
    
    var json: JSON {
        var ret = data
        ret["inv"] = inv.json
        ret["investors"] = JSON(investors as [String: Any])
        return ret
    }
    
    
    var simpleJSON: JSON {
        return JSON(["key": key, "investors": investors] as [String: Any])
    }
}




class MMInvestmentRepo {
    
    static var sharedInstance = MMInvestmentRepo()
    
    var investments = [ENInvestment]()
    
    init () {
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: InvestmentPath)
            
            for file in files {
                
                if file.contains(".") {
                    continue
                }
                
                let json = JSON.read(fromFile: "\(InvestmentPath)/\(file)")!
                investments.append(ENInvestment.deserialize(fromJSON: json))
            }
            
        } catch {
            fatalError()
        }
        
        
        let json = JSON.read(fromFile: "\(BasePath)/investments")?.array ?? []
        
        for j in json {
            for b in self.investments {
                if j["key"].string! == b.key {
                    b.investors = j["investors"].intDictionary ?? [:]
                    break
                }
            }
        }
    }
    
    
    func findInvestment(key: String) -> ENInvestment? {
        for i in self.investments {
            if i.key == key {
                return i
            }
        }
        return nil
    }
    
    
    func findInvestments(keys: [String]) -> [ENInvestment] {
        var ret = [ENInvestment]()
        for k in keys {
            ret.append(findInvestment(key: k)!)
        }
        return ret
    }
    
    
    func investment(forUser key: String) -> [MYInvestment] {
        var ret = [MYInvestment]()
        
        for investment in self.investments {
            for user in investment.investors.keys {
                if user == key {
                    let invest = MYInvestment()
                    invest.key = investment.key
                    invest.progress = investment.investors[key]!
                    ret.append(invest)
                }
            }
        }
        
        return ret
    }
    
    
    
    var json: JSON {
        var jsons = [JSON]()
        for investment in self.investments {
            jsons.append(investment.simpleJSON)
        }
        return JSON(jsons)
    }
    
    
    func save() {
        do {
            try json.description.write(toFile: "\(BasePath)/investments", atomically: true, inAppendMode: false)
        } catch {
            fatalError()
        }
    }
    
}



