//
//  BaseViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

enum NavigationbarContentType {
    
    case text(text: String)
    case image(image: UIImage)
}

enum NavigationbarPosition {
    
    case right
    case left
    case back
}

class BaseViewController: UIViewController {
    
    internal var disposeBag: DisposeBag!
    internal let alertSubject = PublishSubject<AlertViewModel>()
    internal let viewStateSubject = PublishSubject<ViewState>()
    
    private var placeholderView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "beige")
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyNavigationAppearance()
    }
    
    internal func bind() {
        disposeBag = DisposeBag()
        
        viewStateSubject
            .bind(onNext: { [weak self] (state) in
                guard let self = self else { return }
                
                switch state {
                case .normal:
                    self.removePlaceholder()
                    
                case .failure(let viewModel):
                    self.showPlaceholderWith(viewModel: viewModel, type: .error)
                    
                case .loading(let viewModel):
                    self.showPlaceholderWith(viewModel: viewModel, type: .loading)
                    
                }
            })
            .disposed(by: disposeBag)
        
        alertSubject
            .bind(onNext: { [weak self] (alertViewModel) in
                guard let self = self else { return }
                self.buidlAlertWith(viewModel: alertViewModel)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

// MARK: - NavigationControllers methods
extension BaseViewController {
    
    private func applyNavigationAppearance() {
        
        navigationController?.navigationBar.barTintColor = UIColor(named: "darkish_pink")
        navigationController?.navigationBar.tintColor = .white

        let backImage = UIImage(named: "ic_back")
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @discardableResult  func addButtonOnNavigationBar(content: NavigationbarContentType, position: NavigationbarPosition, block: @escaping () -> Void) -> UIBarButtonItem {
        
        let barButtonItem: UIBarButtonItem
        switch content {
        case .text(let title):
            barButtonItem = UIBarButtonItem(title: title, style: .done, target: nil, action: nil)
            
        case .image(let image):
            barButtonItem = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        }
        
        _ = barButtonItem.rx.tap
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {(_) in
                block()
            })
        
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = barButtonItem
            
        case .right:
            navigationItem.rightBarButtonItem = barButtonItem
            
        case .back:
            navigationItem.backBarButtonItem = barButtonItem
        }
        
        return barButtonItem
    }
}

// MARK: - Toast and Placeholders
extension BaseViewController {
    
    private func removePlaceholder() {
        placeholderView?.removeFromSuperview()
    }
    
    private func showPlaceholderWith(viewModel: PlaceholderViewModel, type: PlaceholderType) {
        view.endEditing(true)
        
        let containerView: UIView
        if viewModel.showOnNavigation {
            containerView = navigationController?.view ?? view
        }else {
            containerView = view
        }
        
        switch type {
        case .loading:
            showLoading(viewModel: viewModel, containerView: containerView)
            
        case .error:
            showError(viewModel: viewModel, containerView: containerView)
        }
    }
    
    private func showLoading(viewModel: PlaceholderViewModel, containerView: UIView) {
        removePlaceholder()
        
        let loadingView = LoadingView(type: viewModel.type)
        loadingView.presentOn(parentView: containerView, with: viewModel)
        self.placeholderView = loadingView
    }
    
    private func showError(viewModel: PlaceholderViewModel, containerView: UIView) {
        removePlaceholder()
        
        let errorView = ErrorView()
        errorView.presentOn(parentView: containerView, with: viewModel)
        self.placeholderView = errorView
    }
}

// MARK: - AlertViewModel
extension BaseViewController {
    
    internal func buidlAlertWith(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.preferredStyle)
                
        viewModel.alertActions.forEach { (alertActionViewModel) in
            alert.addAction(alertActionViewModel.transform())
        }
        present(alert, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {

}
