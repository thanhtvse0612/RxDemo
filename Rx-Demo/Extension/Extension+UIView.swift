//
//  Extension+UIView.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base : UIView {
    public var isLoading: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) {view, hidden in
            view.isHidden = hidden
        }
    }
}
