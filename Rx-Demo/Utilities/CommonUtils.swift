//
//  CommonUtils.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 3/17/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class CommonUtils {
    static let utils = CommonUtils()
    
    static var cartObservable : Variable<[Int:(count:Int, product:Product)]> = Variable([:])
    
}
