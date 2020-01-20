//
//  ContainerViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxCocoa
import Cartography

protocol ContainerCoordinatorProtocol: AnyObject {
    
    func updateCurrentPage(_ page: ContentPageType)
}

final class ContainerViewController: BaseViewController {
    
    private var router: ContainerCoordinatorProtocol
    
    private(set) var currentViewController: UIViewController? {
        didSet { updateContainerViewController(oldValue: oldValue) }
    }
    
    init(router: ContainerCoordinatorProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        super.bind()
        
        SessionManager.shared.sessionState
            .bind { [weak self] (state) in
                guard let self = self else { return }

                switch state {
                case .hasSession:
                    self.router.updateCurrentPage(.authenticated)
                case .notHaveSession,
                     .sessionExpired:
                    self.router.updateCurrentPage(.unauthenticated)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ContrainerView transition
extension ContainerViewController {
    
    func setCurrentViewController(viewController: UIViewController) {
        currentViewController = viewController
    }
    
    private func updateContainerViewController(oldValue: UIViewController?) {
        if let currentViewController = currentViewController {
            currentViewController.willMove(toParent: self)
            addChild(currentViewController)
            currentViewController.didMove(toParent: self)
            
            if let oldViewController = oldValue {
                view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
            } else {
                view.addSubview(currentViewController.view)
            }
            
            constrain(currentViewController.view, view, block: { (childView, parentView) in
                childView.edges == parentView.edges
            })
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        if let oldViewController = oldValue {
            self.applyScreenTransition(newViewController: currentViewController, oldViewController: oldViewController)
            if let topController = UIApplication.shared.currentViewController {
                if !topController.isKind(of: ContainerViewController.self) {
                    topController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func applyScreenTransition(newViewController: UIViewController?, oldViewController: UIViewController) {
        if let newViewController = newViewController {
            newViewController.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.size.height))
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                newViewController.view.transform = CGAffineTransform.identity
                oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
                
            }, completion: { (finished) in
                oldViewController.removeDefinitely()
            })
            
        } else {
            oldViewController.removeDefinitely()
        }
    }
}
