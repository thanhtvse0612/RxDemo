//
//  File.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class CartDetailCellViewModel {
    let cart : (count: Int, product: Product)
    var productName : Driver<String>
    var price : Driver<String>
    var count : Driver<String>
    
    init(cart : (count: Int, product:Product)) {
        self.cart = cart
        
        self.productName = Driver.never()
        self.price = Driver.never()
        self.count = Driver.never()
        
        self.productName = Observable
            .just(cart.product.productName)
            .asDriver(onErrorJustReturn: "Empty")
        
        self.price = Observable
            .just(configPriceString(price: Double(self.cart.count * 50)))
            .asDriver(onErrorJustReturn: "0$")
        
        self.count = Observable
            .just("\(self.cart.count)")
            .asDriver(onErrorJustReturn: "0")
    }
    
    func configPriceString(price:Double) -> String {
        return "\(price)$"
    }
        
}
