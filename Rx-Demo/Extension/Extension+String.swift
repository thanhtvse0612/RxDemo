//
//  Extension+String.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
