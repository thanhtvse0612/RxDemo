//
//  Extension+Dictionary.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/16/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation

extension Dictionary {
    var jsonString : String {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        if let jsonData = jsonData {
            return String(data: jsonData, encoding: .utf8)!
        } else {
            return ""
        }
    }
}
