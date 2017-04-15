//
//  ProductCellViewModel.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/6/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class ProductCellViewModel {
    var product : Product

    var title: Driver<String>
    var description: Driver<String>    
    var downloadableImage: Observable<DownloadableImage>
    
    init(product:Product) {
        self.product = product
        self.title = Observable.just(product.productName).asDriver(onErrorJustReturn: "NIL")
        self.description = Observable.just(product.productDescription).asDriver(onErrorJustReturn: "NIL")
        
        let reachabilityService = try! DefaultReachabilityService()
        let imageService = DefaultImageService.sharedImageService
        self.downloadableImage = imageService.imageFromURL(URL(string: product.productImageUrl)!,
                                                                               reachabilityService: reachabilityService)

    }
}
