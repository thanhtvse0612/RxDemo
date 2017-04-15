//
//  ProductsRepsonse.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import ObjectMapper

class ProductsResponse : Mappable {
    var statusCode : Int!
    var message : String!
    var products : [Product]!
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.statusCode <- map["statusCode"]
        self.message <- map["message"]
        
        var tempProducts : [[String : Any]] = []
        products = []
        tempProducts <- map["products"]
        tempProducts.forEach { product in
            let itemProduct = Mapper<Product>().map(JSON: product)
            products.append(itemProduct!)
        }
    }
}
