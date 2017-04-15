//
//  BaseViewController.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/26/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

public class BaseViewController : UIViewController {
    
    var disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
    
    }
}

