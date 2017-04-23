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
    
    var totalPrice = Variable("0 $")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "CartDetailCell", bundle: nil), forCellReuseIdentifier: "CART_CELL")
        tblView.estimatedRowHeight = 144
        tblView.rowHeight = UITableViewAutomaticDimension
        
        Singleton
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
                Singleton.cartObservable.value.removeAll()
            }
            .addDisposableTo(disposeBag)
        
        Singleton
            .cartObservable
            .asObservable()
            .subscribe {[weak self] event in
                guard event.element != nil else {
                    return
                }
                
                self?.totalPrice.value = event.element!.reduce("0 $") { rs, items in
                    let rsStr = rs.components(separatedBy: CharacterSet(charactersIn: "$")).first?.trimmingCharacters(in: CharacterSet.whitespaces)
                    print("\(Int(rsStr!)! + items.value.count * 50) $")
                    return "\(Int(rsStr!)! + items.value.count * 50) $"
                }
            }
            .addDisposableTo(disposeBag)
        
        self.totalPrice
            .asDriver()
            .drive(lbTotalPrice.rx.text)
            .addDisposableTo(disposeBag)
    
        let viewModel = CartDetailViewModel(dict: Singleton.cartObservable.value,
                                            totalPrice: self.totalPrice.value,
                                            tapCheckout: btnCheckout.rx.tap.asObservable())
        
        viewModel
            .checkOutObservable
            .subscribe { [weak self] response in
                guard response.element != nil else {
                    return
                }
                
                if response.element!.statusCode == 1 {
                    let alert = UIAlertController(title: "Success!", message: "Check out successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                        Singleton.cartObservable.value.removeAll()
                    })
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            .addDisposableTo(disposeBag)
        
        viewModel
            .isCheckout
            .bindTo(LoadingView.loadingView.rx.isShowing)
            .addDisposableTo(disposeBag)
    }
    

}
