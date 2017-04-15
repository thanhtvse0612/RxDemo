//
//  CartDetailCell.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxCocoa
import RxSwift

class CartDetailCell: UITableViewCell {
    
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var lbCount: UILabel!
    
    var disposeBag : DisposeBag? = nil
    
    var cartDetailViewModel : CartDetailCellViewModel? {
        didSet {
            let disposableBag = DisposeBag()
            
            guard let cartDetailViewModel = self.cartDetailViewModel  else {
                return
            }
            
            cartDetailViewModel
                .productName
                .drive(lbProductName.rx.text)
                .addDisposableTo(disposableBag)
            
            cartDetailViewModel
                .price
                .drive(lbPrice.rx.text)
                .addDisposableTo(disposableBag)
            
            cartDetailViewModel
                .count
                .drive(lbCount.rx.text)
                .addDisposableTo(disposableBag)
            
            self.btnIncrease
                .rx
                .controlEvent(UIControlEvents.touchUpInside)
                .subscribe { event in
                    
                    if var value = CommonUtils.cartObservable.value[cartDetailViewModel.cart.product.productId] {
                        value.count += 1
                        CommonUtils.cartObservable.value.updateValue(value, forKey: cartDetailViewModel.cart.product.productId)
                    }
                }
                .addDisposableTo(disposableBag)
            
            self.btnDecrease
                .rx
                .controlEvent(UIControlEvents.touchUpInside)
                .subscribe { event in
                    if var value = CommonUtils.cartObservable.value[cartDetailViewModel.cart.product.productId]{
                        if value.count > 0 {
                            value.count -= 1
                        } else {
                            value.count = 0
                        }
                        CommonUtils.cartObservable.value.updateValue(value, forKey: cartDetailViewModel.cart.product.productId)
                    }
                }
                .addDisposableTo(disposableBag)

            
            self.disposeBag = disposableBag
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
