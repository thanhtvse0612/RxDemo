//
//  Receipt.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/16/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import ObjectMapper

class Receipt : Mappable {
    var receiptName : String!
    var datetime : String!
    var product : String!
    var priceTotal : String!
    var method : Int!
    var currencyUnit : Int!
    var userId : Int!
    
    init(priceTotal:String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())

        self.receiptName = "Receipt \(date)"
        self.datetime = date
        self.product = generateJSONStringProducts(dict: Singleton.cartObservable.value)
        self.priceTotal = priceTotal
        self.method = 1
        self.currencyUnit = 1
        self.userId = UserDefaults.standard.integer(forKey: "userId")
        
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.receiptName    <- map["receiptName"]
        self.datetime       <- map["datetime"]
        self.product        <- map["product"]
        self.priceTotal     <- map["priceTotal"]
        self.method         <- map["method"]
        self.currencyUnit   <- map["currencyUnit"]
        self.userId         <- map["userId"]
    }
    
    private func generateJSONStringProducts(dict:[String:(count:Int, product:Product)]) -> String {
        let dict = dict
        var tempDict : [String:Any] = [:]
        dict.forEach { item in
            let value = ["count": "\(item.value.count)", "productId": "\(item.value.product.productId)"]
            tempDict.updateValue(value, forKey: "\(item.key)")
        }
        
        var count = dict.count
        var result = "["
        dict.forEach { item in
            let key = item.key
            let value = item.value
            result += "{ \(key) : { productId : \(value.product.productId), count : \(value.count) } }"
            count -= 1
            if count>0  {
                result += ","
            }
        }
         result += "]"
        return result
    }
    
    
}
