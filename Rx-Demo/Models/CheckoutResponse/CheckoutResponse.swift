//
//  CheckoutResponse.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckoutResponse : Mappable {
    var statusCode : Int!
    var message : String!
    
    required init?(map: Map) {}
 
    func mapping(map: Map) {
        self.statusCode <- map["statusCode"]
        self.message <- map["message"]
    }
}
