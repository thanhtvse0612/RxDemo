//
//  ProductsCell.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//


import RxSwift
import RxCocoa

public class ProductsCell: UITableViewCell {
    var product : Product?
    var disposeBag: DisposeBag?
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    
    var viewModel : ProductCellViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else {
                return
            }
            
            viewModel.downloadableImage
                .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
                .drive(self.imgProduct.rx.downloadableImageAnimated(kCATransitionFade))
                .addDisposableTo(disposeBag)
            
            viewModel.title
                .map(Optional.init)
                .drive(self.lbTitle.rx.text)
                .addDisposableTo(disposeBag)
            
            viewModel.description
                .map(Optional.init)
                .drive(self.lbDescription.rx.text)
                .addDisposableTo(disposeBag)
            
//            self.downloadableImage?
//                .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
//                .drive(imgProduct.rx.downloadableImageAnimated(kCATransitionFade))
//                .addDisposableTo(disposeBag)
            
            self.disposeBag = disposeBag
        }
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
