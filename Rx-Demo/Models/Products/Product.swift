//
//  Product.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {
    var productId : Int!
    var productName : String!
    var productPrice : String!
    var productDescription : String!
    var productImageUrl : String!
    
    var productDistrictName: String!
    var productRate : String!
    var productLatitude : Double!
    var productLongitude : Double!
    var productRestaurantName : String!
    var productUrlRelated : String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productRate <- map["rating"]
        productId <- map["productId"]
        productName <- map["productName"]
        productPrice <- map["productPrice"]
        productDescription <- map["addressName"]
        productImageUrl <- map["productImageUrl"]
        productDistrictName <- map["districtName"]
        productLatitude <- map["latitude"]
        productLongitude <- map["longitude"]
        
        productRestaurantName <- map["restaurantName"]
        productUrlRelated <- map["urlrelate"]
    }
    
}

extension Product {
    static func == (left:Product, right:Product) -> Bool{
        return left.productName == right.productName
    }
}
