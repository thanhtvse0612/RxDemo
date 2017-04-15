//
//  LoginResponse.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import ObjectMapper

class LoginResponse : Mappable {
    var statusCode : Int!
    var message : String!
    var user : User!
    
    required init?(map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        self.statusCode <- map["statusCode"]
        self.message <- map["message"]
        self.user <- map["user"]
    }
    
}
