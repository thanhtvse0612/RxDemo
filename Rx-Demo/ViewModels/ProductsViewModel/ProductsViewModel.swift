//
//  ProductsModelView.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/28/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxCocoa
import RxSwift

class ProductsViewModel {
    let productObservable: Observable<[Product]>
    
    init(dependencies: ServerAPI) {
        let API = dependencies
        
        productObservable = API
            .getListProduct()
            .map{ response in
                (response.products)!
            }
    }
}
