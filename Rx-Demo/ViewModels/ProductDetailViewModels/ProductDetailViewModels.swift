//
//  ProductDetailViewModels.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 3/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ProductDetailViewModel {
    var loadProductDetail : Observable<Product>
    var isLoading : Observable<Bool>
    
    init(productId: Int) {
        let isLoading = ActivityIndicator()
        self.isLoading = isLoading.asObservable()
        
        loadProductDetail = APIRequest
            .sharedAPI
            .getProductDetail(productId: productId)
            .trackActivity(isLoading)
            .observeOn(MainScheduler.instance)
            
            .shareReplay(1)
    }
}
