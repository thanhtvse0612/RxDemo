//
//  LoginViewController.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class LoginViewController: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var errorUsername: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var btRegister: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewModel = LoginViewModel(inputResource: (username: tfUsername.rx.text.orEmpty.asObservable(),
                                                            password: tfPassword.rx.text.orEmpty.asObservable(),
                                                            loginTapped: btLogin.rx.tap.asObservable()),
                                            dependencies: (serverAPI: APIRequest.sharedAPI,
                                                           validateService: LoginService.sharedLoginService))
        
        loginViewModel
            .isEnableLogin
            .subscribe(
                onNext: { [weak self] isEnableLogin in
                    self?.btLogin.isEnabled = isEnableLogin
            })
            .addDisposableTo(self.disposeBag)
        
        loginViewModel
            .validatedUsername
            .bindTo(errorUsername.rx.validationResult)
            .addDisposableTo(self.disposeBag)
        
        loginViewModel
            .validatedPassword
            .bindTo(errorPassword.rx.validationResult)
            .addDisposableTo(self.disposeBag)

        loginViewModel
            .isLogining
            .bindTo(LoadingView.loadingView.rx.isShowing)
            .addDisposableTo(self.disposeBag)
        
        loginViewModel
            .isLogined
            .subscribe(
                onNext: { isLogined in
                    if isLogined.statusCode == Constant.StatusCode.statusCode_OK {
                        UserDefaults.standard.set(isLogined.user.userId, forKey: "userId")
                        let productsViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
                        AppDelegate.appDelegate.navigationController = UINavigationController(rootViewController: productsViewController)
                        AppDelegate.appDelegate.window?.rootViewController = AppDelegate.appDelegate.navigationController
                    } else {
                        print("Login Failed")
                    }
            })
            .addDisposableTo(self.disposeBag)

        
        let tapBackground = UITapGestureRecognizer()
        tapBackground
            .rx
            .event
            .subscribe(
                onNext: { [weak self] (event) in
                    self?.tfPassword.endEditing(true)
                    self?.tfUsername.endEditing(true)
            })
            .addDisposableTo(self.disposeBag)
        self.view.addGestureRecognizer(tapBackground)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
}
