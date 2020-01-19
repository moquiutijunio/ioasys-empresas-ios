//
//  LoginViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

final class LoginViewController: BaseScrollViewController {
    
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
        print("TODO loginButtonDidTap e:\(email) p:\(password)")
    }
}
