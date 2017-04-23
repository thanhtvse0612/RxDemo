//
//  CartDetailViewModel.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class CartDetailViewModel {
    var checkOutObservable : Observable<CheckoutResponse>
    var isCheckout : Observable<Bool>
    
    init(dict:[String:(count:Int, product:Product)], totalPrice:String ,tapCheckout:Observable<Void>) {
        let activityIndicator = ActivityIndicator()
        self.isCheckout = activityIndicator.asObservable()
        self.checkOutObservable = Observable.empty()
        
        self.checkOutObservable = tapCheckout
            .flatMapLatest { _ in
                return APIRequest
                    .sharedAPI
                    .checkOut(receipt: Receipt(priceTotal: totalPrice))
                    .observeOn(MainScheduler.instance)
                    .trackActivity(activityIndicator)
            }.shareReplay(1)
    }
    

}
