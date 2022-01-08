//
//  SignInViewControllerModel.swift
//  NetworkModule
//
//  Created by Kang, Su Jin (강수진) on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewControllerModel {
    //View -> ViewModel
    let username = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    
    //ViewModel -> View
    let isValid: Observable<Bool>
    
    init() {
        isValid = Observable.combineLatest(self.username.asObservable(),
                                           self.password.asObservable(),
                                           self.email.asObservable()) { (username, password, email) in
            return username.count > 0
            && password.count > 0
            && email.count > 0
        }
    }
}
