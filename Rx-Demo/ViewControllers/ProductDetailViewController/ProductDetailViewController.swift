//
//  ProductDetailViewController.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 3/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxCocoa
import RxSwift

class ProductDetailViewController: BaseViewController {
    
    var productId : Int?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    @IBOutlet weak var lbLongitude: UILabel!
    @IBOutlet weak var lbLatitude: UILabel!
    @IBOutlet weak var lbDistrict: UILabel!
    
    var downloadableImage: Observable<DownloadableImage>?{
        didSet{
            self.downloadableImage?
                .catchErrorJustReturn(DownloadableImage.offlinePlaceholder)
                .subscribe(imgProduct.rx.downloadableImageAnimated(kCATransitionFade))
                .addDisposableTo(disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let productId = self.productId else {
            return
        }
        let productDetailViewModel = ProductDetailViewModel(productId:productId)

        productDetailViewModel
            .isLoading
            .bindTo(LoadingView.loadingView.rx.isShowing)
            .addDisposableTo(disposeBag)
    
        
        productDetailViewModel
            .loadProductDetail
            .subscribe(onNext: { [weak self] product in
                self?.lbTitle.text = product.productName
                self?.lbRate.text = product.productRate
                self?.lbAddress.text = product.productDescription
                self?.lbDistrict.text = product.productDistrictName
                self?.lbLongitude.text = String(product.productLongitude)
                self?.lbLatitude.text = String(product.productLatitude)
                
                let reachabilityService = try! DefaultReachabilityService()
                self?.downloadableImage = DefaultImageService
                    .sharedImageService
                    .imageFromURL(URL(string: product.productImageUrl)!,reachabilityService: reachabilityService)
            })
            .addDisposableTo(disposeBag)
    }

}
