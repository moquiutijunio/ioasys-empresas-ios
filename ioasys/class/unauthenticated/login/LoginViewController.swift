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
        
        addChildViewToScrollView(childView: signInView)
    }
}

// MARK: - SignInViewModelCallbackProtocol
extension LoginViewController: SignInViewModelCallbackProtocol {
    
    func loginButtonDidTap(email: String, password: String) {
        loginDisposeBag = DisposeBag()
        
        viewStateSubject.onNext(.loading(PlaceholderViewModel(text: NSLocalizedString("sign.in.loading", comment: ""))))
        
        apiClient.loginWith(email: email, password: password)
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                self.viewStateSubject.onNext(.normal)
                
                switch event {
                case .error(let error):
                    
                    var alertActionViewModels = [AlertActionViewModel]()
                    alertActionViewModels.append(AlertActionViewModel(title: NSLocalizedString("try.again", comment: ""), action: { [unowned self] in
                        self.loginButtonDidTap(email: email, password: password)
                    }))
                    
                    alertActionViewModels.append(AlertActionViewModel(title: NSLocalizedString("cancel", comment: "")))
                    
                    self.alertSubject.onNext(AlertViewModel(title: NSLocalizedString("error.title", comment: ""),
                                                            message: error.localizedDescription,
                                                            actions: alertActionViewModels))
                default:
                    break
                }
            }
            .disposed(by: loginDisposeBag)
    }
}
