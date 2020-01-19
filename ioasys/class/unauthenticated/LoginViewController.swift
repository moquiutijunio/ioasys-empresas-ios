//
//  LoginViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import Cartography

final class LoginViewController: BaseScrollViewController {
    
    private var loginDisposeBag: DisposeBag!
    private let apiClient = APIClient()
    
    private lazy var signInView: SignInView = {
        return SignInView.instantiateFromNib(viewModel: SignInViewModel(callback: self))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyLayout()
        addChildViewToScrollView(childView: signInView)
    }
    
    private func applyLayout() {
        view.backgroundColor = UIColor(named: "beige")
    }
}

// MARK: - SignInViewModelCallbackProtocol
extension LoginViewController: SignInViewModelCallbackProtocol {
    
    func loginButtonDidTap(email: String, password: String) {
        loginDisposeBag = DisposeBag()
        
        apiClient.loginWith(email: email, password: password)
            .subscribe { (event) in
                
                switch event {
                case .success:
                    print("TODO event success response")
                case .error(let error):
                    print("TODO event error response \(error)")
                }
            }
            .disposed(by: loginDisposeBag)
    }
}
