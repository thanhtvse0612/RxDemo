//
//  Extension+Array.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/14/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation

extension Array {
    func unique<Element : Hashable>(with array:[Element]) -> [Element] {
        var temp : [Element:Bool] = [:]
        
        return array.filter { element in
            return temp.updateValue(true, forKey: element) == nil
        }
        
    }
}
