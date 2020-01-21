//
//  LoginView.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignInViewModelProtocol {
    
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var buttonIsEnabled: Driver<Bool> { get }
    
    func loginButtonDidTap()
}

final class SignInView: UIView {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailIconImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailSeparetorView: UIView!
    @IBOutlet weak var passwordIconImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSeparetorView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    private var disposeBag: DisposeBag!
    private var viewModel: SignInViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
        
        #if DEBUG
        emailTextField.text = "testeapple@ioasys.com.br"
        passwordTextField.text = "12341234"
        #endif
    }
    
    private func applyLayout() {
        backgroundColor = .clear
        emailSeparetorView.backgroundColor = UIColor(named: "charcoal_grey")
        passwordSeparetorView.backgroundColor = UIColor(named: "charcoal_grey")
        
        logoImageView.image = UIImage(named: "img_logo_colorfull")
        logoImageView.contentMode = .scaleAspectFit
        
        emailIconImageView.image = UIImage(named: "ic_email")
        emailIconImageView.contentMode = .scaleAspectFit
        
        passwordIconImageView.image = UIImage(named: "ic_password")
        passwordIconImageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .textStyleBold(size: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "charcoal_grey")
        titleLabel.text = NSLocalizedString("sign.in.title", comment: "").uppercased()
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .textStyleRegular(size: 15)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(named: "charcoal_grey")
        descriptionLabel.text = NSLocalizedString("sign.in.description", comment: "")
        
        loginButton.applyAppearance(appearance: .main, title: NSLocalizedString("enter", comment: "").uppercased(), cornerRadius: 6)

        emailTextField.font = .textStyleRegular(size: 15)
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .clear
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.textColor = UIColor(named: "charcoal_grey")
        emailTextField.placeholder = NSLocalizedString("email", comment: "")
        emailTextField.addToolBar(title: NSLocalizedString("ok", comment: ""))
        
        passwordTextField.font = .textStyleRegular(size: 15)
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .clear
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.textColor = UIColor(named: "charcoal_grey")
        passwordTextField.addToolBar(title: NSLocalizedString("ok", comment: ""))
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")
    }
    
    private func bindIn(viewModel: SignInViewModelProtocol) {
        disposeBag = DisposeBag()
        
        emailTextField.rx.text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { _ in viewModel.loginButtonDidTap() }
            .disposed(by: disposeBag)
        
        viewModel.buttonIsEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}

// MARK: - UINib
extension SignInView {
    
    class func instantiateFromNib(viewModel: SignInViewModelProtocol) -> SignInView {
        let view =  UINib(nibName: "SignInView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SignInView
        view.bindIn(viewModel: viewModel)
        return view
    }
}
