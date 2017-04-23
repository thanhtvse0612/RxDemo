//
//  Singleton.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 3/17/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class Singleton {
    
    static let utils = Singleton()
    
    static var cartObservable : Variable<[String:(count:Int, product:Product)]> = Variable([:])
    
}
