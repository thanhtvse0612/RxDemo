//
//  ProductsViewController.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/27/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

class ProductsViewController: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    let imageService = DefaultImageService.sharedImageService
    var refreshControl = UIRefreshControl()
    var productsViewModel : ProductsViewModel?
    var barButtonItem : UIBarButtonItem?
    var btnBarBadge : BadgeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Product"

        self.productsViewModel = ProductsViewModel(dependencies: APIRequest.sharedAPI)
        configTableView()
        bindingDataTableView()
        configCartImage()
    }
    
    func configCartImage()  {
        let customButton = UIButton(type: UIButtonType.custom)
        customButton.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
        customButton.setImage(UIImage(named: "Cart"), for: .normal)
        customButton
            .rx
            .tap
            .debug()
            .subscribe { event in
                let cartDetailViewController = CartDetailViewController(nibName: "CartDetailViewController", bundle: nil)
                self.navigationController?.pushViewController(cartDetailViewController, animated: true)
            }.addDisposableTo(disposeBag)
        
        self.btnBarBadge = BadgeButton()
        self.btnBarBadge.setup(customButton: customButton)
        self.btnBarBadge.badgeValue = "0"
        self.btnBarBadge.badgeOriginX = 20.0
        self.btnBarBadge.badgeOriginY = -4

        self.navigationItem.rightBarButtonItem = self.btnBarBadge
        
        Singleton
            .cartObservable
            .asObservable()
            .subscribe { value in
            self.btnBarBadge.badgeValue = "\(value.element!.count)"
        }.addDisposableTo(disposeBag)
    }

    func configTableView()  {
        tblView.register(UINib(nibName: "ProductsCell", bundle: nil),
                         forCellReuseIdentifier: "CELL")
        
        tblView.estimatedRowHeight = 144
        tblView.rowHeight = UITableViewAutomaticDimension
    }
    
    func bindingDataTableView()  {
        
        tblView.refreshControl = self.refreshControl
        
        let loadingResult = productsViewModel!
            .productObservable
            .map { result in
                result.map(ProductCellViewModel.init)
            }.catchErrorJustReturn([])
        
        let isLoading = ActivityIndicator()
        let refreshResult = tblView
            .refreshControl!
            .rx
            .controlEvent(UIControlEvents.valueChanged)
            .flatMap {[weak self]  _ -> Observable<[Product]> in
                return (self?.productsViewModel?.productObservable.trackActivity(isLoading))!
            }
            .map { result in
                result.map(ProductCellViewModel.init)
            }
            .catchErrorJustReturn([])
        
        loadingResult
            .concat(refreshResult)
            .bindTo(tblView.rx.items(cellIdentifier: "CELL", cellType: ProductsCell.self)) { (row, viewModel, cell) in
                cell.viewModel = viewModel
                cell.btnBuy
                    .rx
                    .controlEvent(UIControlEvents.touchUpInside)
                    .subscribe { event in
                        guard let viewModel = cell.viewModel else {
                            return
                        }
                        print(viewModel.product.productName)
                        
                        if var value = Singleton.cartObservable.value["\(viewModel.product.productId)"] {
                            value.count += 1
                            value.product = viewModel.product
                            Singleton.cartObservable.value.updateValue(value, forKey: "\(viewModel.product.productId)")
                        } else {
                            Singleton.cartObservable.value["\(viewModel.product.productId)"] = (1, viewModel.product)
                        }
                        
                        
                    }
                    .addDisposableTo(cell.disposeBag!)
            }
            .addDisposableTo(disposeBag)
        
        isLoading
            .asObservable()
            .bindTo(self.refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)
        
        tblView
            .rx
            .modelSelected(ProductCellViewModel.self)
            .subscribe(onNext:  { [weak self] value in
                let productDetailViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
                productDetailViewController.productId = value.product.productId
                self?.navigationController?.pushViewController(productDetailViewController, animated: true)
            })
            .addDisposableTo(disposeBag)
    }
}
