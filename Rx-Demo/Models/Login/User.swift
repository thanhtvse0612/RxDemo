//
//  User.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 3/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var username: String!
    var userId: String!
    var userDisplayName : String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        username <- map["username"]
        userId <- map["userId"]
        userDisplayName <- map["userDisplayName"]
    }
}
