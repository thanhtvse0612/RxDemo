//
//  LoginViewModel.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class LoginViewModel {
    let validatedUsername : Observable<ValidationResult>
    let validatedPassword : Observable<ValidationResult>
    
    let isEnableLogin : Observable<Bool>
    let isLogined : Observable<LoginResponse>
    let isLogining : Observable<Bool>
    
    init(inputResource: (username:Observable<String>, password:Observable<String>, loginTapped: Observable<Void>),
         dependencies: (serverAPI:ServerAPI, validateService:ValidationService)) {
        let API = dependencies.serverAPI
        let validateService = dependencies.validateService
        
        validatedUsername = inputResource.username
            .map { username in
                return validateService.validateUsername(username: username)
            }
            .shareReplay(1)
        
        validatedPassword = inputResource.password
            .map { password in
                return validateService.validatePassword(password: password)
            }
            .shareReplay(1)
        
        let signining = ActivityIndicator()
        self.isLogining = signining.asObservable()
        
        let latestUsernameAndPassword = Observable.combineLatest(inputResource.username, inputResource.password) { ($0, $1)}
        
        isLogined = inputResource.loginTapped.withLatestFrom(latestUsernameAndPassword)
            .flatMapLatest { username, password in
                return API.login(username: username, password: password)
                    .observeOn(MainScheduler.instance)
                    .trackActivity(signining)
            }.shareReplay(1)
        
        isEnableLogin = Observable
            .combineLatest(validatedUsername, validatedPassword, isLogining.asObservable()) { username, password, isLogining  in
                return username.isValid && password.isValid && !isLogining
            }
            .distinctUntilChanged()
            .shareReplay(1)
    }
}

class LoginService: ValidationService {
    static let sharedLoginService = LoginService()
    
    let minUsername = 8
    let maxUsername = 10
    
    let minPassword = 8
    let maxPassword = 10
    
    func validatePassword(password: String) -> ValidationResult {
        let characterCount = password.characters.count
        
        if characterCount == 0 {
            return .empty
        }
        
        if characterCount < minPassword {
            return .failed(message: "Password must more than 8 characters")
        }
        
        if characterCount > maxPassword {
            return .failed(message: "Password must less than 10 characters")
        }
        
        return .ok(message: "Success")
    }
    
    func validateUsername(username: String) -> ValidationResult {
        let characterCount = username.characters.count
        
        if characterCount == 0 {
            return .empty
        }
        
        if characterCount < minUsername {
            return .failed(message: "Username must more than 8 characters")
        }
        
        if characterCount > maxUsername {
            return .failed(message: "Username must less than 10 characters")
        }
        
        return .ok(message: "Success")
    }
    
    func validateConfirmPassword(password: String, confirmPassword: String) -> ValidationResult {
        let characterCount = confirmPassword.characters.count
        
        if characterCount == 0 {
            return .empty
        }
        
        if characterCount < minPassword {
            return .failed(message: "Confirm Password must more than 8 characters")
        }
        
        if characterCount > maxPassword {
            return .failed(message: "Confirm Password must less than 10 characters")
        }
        
        
        if password != confirmPassword {
            return .failed(message: "Confirm Password is not match")
        }
        
        return .ok(message: "Success")
    }
}
