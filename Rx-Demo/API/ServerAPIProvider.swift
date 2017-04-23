//
//  ServerAPIProvider.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation

enum API  {
    case login(String,String)
    case register(String, String, String)
    case getListProduct()
    case getProductDetail(Int)
    case checkOut(String, String, String, String, Int, Int, Int)
}

extension API : RequestType {
    var baseURL: String {
//        return "http://192.168.1.154:3000/api/"
        return "http://172.20.10.5:3000/api/"
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json", "Accept": "application/json"]
    }
    
    var method: HTTPMethod {
        switch self {
        case .getListProduct:
            return .GET
        default:
            return .POST
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .login(username, password):
            return ["username":username, "password":password]
        case let .register(username, password, confirmedPassword):
            return ["username":username, "password":password, "confirmedPassword":confirmedPassword]
        case let .getProductDetail(productId):
            return ["productId":productId]
        case let .checkOut(receiptName, datetime, products, totalPrice, method, currencyUnit, userId):
            print(["receiptName": receiptName,
                   "datetime": datetime,
                   "product": products,
                   "priceTotal": totalPrice,
                   "method": method,
                   "currencyUnit": currencyUnit,
                   "userId": userId])
            return ["receiptName": receiptName,
                    "datetime": datetime,
                    "product": products,
                    "priceTotal": totalPrice,
                    "method": method,
                    "currencyUnit": currencyUnit,
                    "userId": userId]
        default:
            return nil
        }

    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        case .getListProduct:
            return "listProduct"
        case .getProductDetail:
            return "productDetail"
        case .checkOut:
            return "checkout"
        }
    }
}
