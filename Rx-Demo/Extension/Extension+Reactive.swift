//
//  Extension+Reactive.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/26/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    var validationResult: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
            label.isHidden = result.isValid
        }
    }
}
