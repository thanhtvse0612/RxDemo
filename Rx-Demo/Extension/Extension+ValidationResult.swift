//
//  Extension+ValidationResult.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/26/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import UIKit

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

extension ValidationResult {
    var description: String {
        switch self {
        case .ok:
            return ""
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
    
    var isValid : Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
}
