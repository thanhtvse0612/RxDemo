//
//  File.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

protocol ServerAPI {
    func login(username:String, password:String) -> Observable<LoginResponse>
    func register(username:String, password:String, confirmedPassword:String) -> Observable<Bool>
    func getListProduct()  -> Observable<ProductsResponse>
    func getProductDetail(productId:Int) -> Observable<Product>
}

protocol ValidationService {
    func validateUsername(username: String) -> ValidationResult
    func validatePassword(password: String) -> ValidationResult
    func validateConfirmPassword(password: String, confirmPassword: String) -> ValidationResult
}

