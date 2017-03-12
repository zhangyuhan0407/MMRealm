//
//  MMFabaoRepo.swift
//  MMRealm
//
//  Created by yuhan zhang on 1/14/17.
//
//

import Foundation
import OCTJSON
import OCTFoundation


//
//enum FabaoProp {
//    case baoji
//    case shanbi
//    case mingzhong
//    case gedang
//    case zaisheng
//    case xixue
//    case fantanwuli
//    case fantanfashu
//}
//
//
//
//class FabaoRepo {
//    
//    static func create(fromJSON json: JSON) -> MMFabao? {
//        return nil
//    }
//    
//    
//    static func create(rarity: Int) -> MMFabao {
//        
//        func createProp(maxValue: Int) -> KindLevelType {
//            let ranKey = Int.random() / 12
//            let key: String
//            switch ranKey {
//            case 1:
//                key = "baoji"
//            case 2:
//                key = "shanbi"
//            case 3:
//                key = "mingzhong"
//            case 4:
//                key = "gedang"
//            case 5:
//                key = "zaisheng"
//            case 6:
//                key = "xixue"
//            case 7:
//                key = "fantanwuli"
//            default:
//                key = "fantanfashu"
//            }
//            
//            
//            let ranLevel = Int.random() % maxValue
//            
//            
//            return KindLevelType(key: key, level: ranLevel)
//        }
//        
//        
//        
//        
//        let baoshiCount: Int
//        let propMaxValue: Int
//        
//        switch rarity {
//        case 1:
//            baoshiCount = 3
//            propMaxValue = 10
//        case 2:
//            baoshiCount = 4
//            propMaxValue = 20
//        case 3:
//            baoshiCount = 5
//            propMaxValue = 30
//        default:
//            baoshiCount = 5
//            propMaxValue = 40
//        }
//        
//        var fabao = MMFabao()
//        
//        fabao.baoshiCount = baoshiCount
//        fabao.prop1 = createProp(maxValue: propMaxValue).description
//        fabao.prop2 = createProp(maxValue: propMaxValue).description
//        fabao.prop3 = createProp(maxValue: propMaxValue).description
//        
//        
//        return fabao
//    }
//    
//    
//    
//    
//}
