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
                    self.buidlAlertController(viewModel: viewModel)
                    
                case .loading(let viewModel):
                    self.buildLoadingView(viewModel: viewModel)
                }
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
        guard let navigationController = navigationController else { return }
        
        let backImage = UIImage(named: "ic_back")
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController.navigationBar.barTintColor = UIColor(named: "darkish_pink")
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.textStyleBold(size: 15)]
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

// MARK: - Placeholders and AlertViewModel
extension BaseViewController {
    
    private func removePlaceholder() {
        placeholderView?.removeFromSuperview()
    }
    
    private func buildLoadingView(viewModel: PlaceholderViewModel) {
        view.endEditing(true)
        
        removePlaceholder()
        
        let loadingView = LoadingView()
        loadingView.presentOn(parentView: view, with: viewModel)
        self.placeholderView = loadingView
    }
    
    private func buidlAlertController(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.preferredStyle)
                
        viewModel.alertActions.forEach { (alertActionViewModel) in
            alert.addAction(alertActionViewModel.transform())
        }
        present(alert, animated: true)
    }
}
