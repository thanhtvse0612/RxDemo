//
//  APIRequest.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper


class APIRequest : ServerAPI {
    static let sharedAPI = APIRequest()
    
    init() {}
    
    func login(username: String, password: String) -> Observable<LoginResponse> {
       return APIProvider<API>(.login(username, password)).request()
    }
    
    func register(username: String, password: String, confirmedPassword: String) -> Observable<Bool> {
        return Observable.empty()
    }
    
    func getListProduct() -> Observable<ProductsResponse> {
        return APIProvider<API>(.getListProduct()).request()
    }
    
    func getProductDetail(productId:Int) -> Observable<Product> {
        return APIProvider<API>(.getProductDetail(productId)).request()
    }
    
    func checkOut(receipt:Receipt) -> Observable<CheckoutResponse> {
        return APIProvider<API>(.checkOut(receipt.receiptName,
                                          receipt.datetime,
                                          receipt.product,
                                          receipt.priceTotal,
                                          receipt.method,
                                          receipt.currencyUnit,
                                          receipt.userId)).request()
    }
}
