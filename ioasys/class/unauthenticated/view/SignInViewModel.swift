//
//  SignInViewModel.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignInViewModelCallbackProtocol: AnyObject {
    
    func loginButtonDidTap(email: String, password: String)
}

final class SignInViewModel: NSObject, SignInViewModelProtocol {
    
    private weak var callback: SignInViewModelCallbackProtocol?
    
    let email = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    
    var buttonIsEnabled: Driver<Bool> {
        return Observable
            .combineLatest(email, password) { (email, password) -> Bool in
                guard let email = email, let password = password else { return false }
                return (email.isValidEmail && !password.isEmpty)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    init(callback: SignInViewModelCallbackProtocol?) {
        super.init()
        self.callback = callback
    }
    
    func loginButtonDidTap() {
        guard let email = email.value, let password = password.value else { return }
        callback?.loginButtonDidTap(email: email, password: password)
    }
}
