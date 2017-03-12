//
//  OCTDAO.swift
//  SpriteLabServer
//
//  Created by yuhan zhang on 6/28/16.
//
//

import PostgreSQL
import OCTFoundation
import OCTJSON


protocol OCTDAO {
    
    associatedtype Model: OCTModel
    
    static var TableName: String { get }
    
    static var PrimaryKey: String { get }
    
    
    
    func findOne(id: String) -> Model?
    
    func findByKey(key: String, value: Any) -> [Model]?

    func save(_ obj: Model) throws

}


extension OCTDAO {
    
    var psql: PGManager {
        return PGManager.sharedInstance
    }
    
    func findOne(id: String) -> Model? {
        
        let result = psql.exec(Self.queryFindOne(id: id))
        let status = result.status()
        
        
        var params = [String: Any]()
        
        if status == .commandOK || status == .tuplesOK {
            
            if result.numFields() == 0 || result.numTuples() == 0 {
                return nil
            }
            
            for i in 0..<result.numFields() {
                
                let k = result.fieldName(index: i)!
                let v = result.getFieldString(tupleIndex: 0, fieldIndex: i)!
                
                if postgresResultIsArray(s: v) {
                    params.updateValue(postgresResultArray(s: v), forKey: k)
                } else {
                    params.updateValue(v, forKey: k)
                }
            }
            
        }
        else {
            Logger.error("BAD QUERY IN findOne() status: \(status)")
            
            return nil
        }
        
        
        return Model(fromDictionary: params)
    }
    
    
    func findByKey(key: String, value: Any) -> [Model]? {
        let result = psql.exec(Self.queryFindByKey(key: key, value: value))
        let status = result.status()
        
        
        var entities: [Model]?
        
        if status == PGResult.StatusType.commandOK || status == PGResult.StatusType.tuplesOK {
            
            if result.numFields() == 0 || result.numTuples() == 0 {
                return nil
            }
            
            if entities == nil {
                entities = []
            }
            
            for i in 0..<result.numTuples() {
                var params = [String: Any]()
                for j in 0..<result.numFields() {
                    let key = result.fieldName(index: j)!
                    let value = result.getFieldString(tupleIndex: i, fieldIndex: j)!
                    params.updateValue(value, forKey: key)
                }
                entities!.append(Model(fromDictionary: params))
            }
            
        } else {
            Logger.error("BAD QUERY IN findByKey() status: \(status)")
        }
        
        return entities
    }
    
    
    func save(_ obj: Model) throws {
        if hasEntity(obj) {
            _ = psql.exec(Self.queryUpdate(forModel: obj))
        } else {
            _ = psql.exec(Self.queryInsert(forModel: obj))
        }
    }
    
    
    func hasEntity(_ obj: Model) -> Bool {
        
        let value = Self.primaryValue(forEntity: obj) as! String
        
        if let _ = self.findOne(id: value) {
            return true
        }
        
        return false
    }
    
    
    static func primaryValue(forEntity obj: OCTModel) -> Any {
        let mir = Mirror(reflecting: obj)
        
        for (key, value) in mir.children {
            if key == Self.PrimaryKey {
                return value
            }
        }
        
        fatalError("EVERY ENTITY SHOULD HAVE A PRIMARY VALUE")
    }
    
}




//MARK:-  Query String



extension OCTDAO {
    
    static func queryFindOne(id: String) -> String {
        let query = "SELECT * FROM \(Self.TableName) WHERE \(Self.PrimaryKey) = \(postgresStyleString(forValue: id))"
        Logger.debug(query)
        return query
    }
    
    static func queryFindByKey(key: String, value: Any) -> String {
        let query = "SELECT * FROM \(Self.TableName) WHERE \(key) = \(postgresStyleString(forValue: value))"
        Logger.debug(query)
        return query
    }
    
    static func queryUpdate(forModel obj: Model) -> String {
        var query = "UPDATE \(Self.TableName) SET "
        
        let params = obj.toDictionary()
        
        for param in params {
            let value = param.1
            let key = param.0
            
            if isAnyArray(value) {
                query.append("\(key) = \(postgresArrayString(value)),")
            } else {
                query.append("\(key) = \(postgresStyleString(forValue: value)),")
            }
        }
        
        query.removeLastCharacter()
        
        
        let primaryValue = Self.primaryValue(forEntity: obj)
        
        query.append(" WHERE \(Self.PrimaryKey) = \(postgresStyleString(forValue: primaryValue))")
        
        Logger.debug(query)
        
        return query
    }
    
    
    static func queryInsert(forModel obj: Model) -> String {
        var query = "INSERT INTO \(Self.TableName) "
        var keys = "("
        var values = " VALUES("
        
        let params = obj.toDictionary()
        
        for param in params {
            let value = param.1
            let key = param.0
            
            keys.append(key + ",")
            
            if isAnyArray(value) {
                values.append("\(postgresArrayString(value)),")
            } else {
                values.append("\(postgresStyleString(forValue: value)),")
            }
            
        }
        
        keys.removeLastCharacter()
        values.removeLastCharacter()
        
        keys.append(")")
        values.append(")")
        
        query += keys
        query += values
        
        Logger.debug(query)
        
        return query
    }
    
    
}




 

//MARK:- convenient func



func postgresStyleString(forValue value: Any) -> String {
    if value is String {
        return "'\(value)'"
    } else {
        return "\(value)"
    }
}



func postgresResultIsArray(s: String) -> Bool {
    return s.hasPrefix("{") && s.hasSuffix("}")
}



func postgresArrayString(_ array: Any) -> String {
    
    func postgresArrayStyleString(forValue value: Any) -> String {
        if value is String {
            return "\"\(value)\""
        } else {
            return "\(value)"
        }
    }
    
    var ret = "'{"
    forEachArray(array) { (element) in
        ret.append("\(postgresArrayStyleString(forValue: element)),")
    }
    ret.removeLastCharacter()
    ret.append("}'")
    return ret
}







func postgresResultArray(s: String) -> [Any] {
    var ss = String(s.characters.dropFirst())
    ss = String(ss.characters.dropLast())
    
    var ret = [Any]()
    
    let values = ss.components(separatedBy: ",")
    
    if values.count == 0 {
        return ret
    }
    
    for v in values {
        ret.append(v)
    }
    
    return ret
}


private extension String {
    
    mutating func removeLastCharacter() {
        self = String(self.characters.dropLast())
    }
    
    mutating func replaceLastCharacter(by char: Character) {
        self.removeLastCharacter()
        self.append(char)
    }
    
}



























