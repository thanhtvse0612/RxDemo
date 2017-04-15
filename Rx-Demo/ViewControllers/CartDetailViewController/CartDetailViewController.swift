//
//  CartDetailViewController.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import UIKit
import RxSwift

class CartDetailViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnCheckout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "CartDetailCell", bundle: nil), forCellReuseIdentifier: "CART_CELL")
        tblView.estimatedRowHeight = 144
        tblView.rowHeight = UITableViewAutomaticDimension
        
        CommonUtils
            .cartObservable
            .asObservable()
            .bindTo(tblView.rx.items(cellIdentifier: "CART_CELL", cellType: CartDetailCell.self)) { (row, item, cell) in
                cell.cartDetailViewModel = CartDetailCellViewModel(cart: item.value)
            }

            .addDisposableTo(disposeBag)
        
        btnClear
            .rx
            .tap
            .subscribe { event in
                CommonUtils.cartObservable.value.removeAll()
            }
            .addDisposableTo(disposeBag)
        
        
    }
    

}
