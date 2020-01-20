//
//  ContainerCoordinator.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

enum ContentPageType {
    
    case unauthenticated
    case authenticated
}

final class ContainerCoordinator: NSObject {
    
    private let window: UIWindow
    private var currentPage: ContentPageType?
    
    private lazy var containerViewController: ContainerViewController = {
        return ContainerViewController(router: self)
    }()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func start(scene: UIWindowScene) {
        window.rootViewController = containerViewController
        window.makeKeyAndVisible()
        window.windowScene = scene
    }
}

// MARK: - ContainerCoordinatorProtocol
extension ContainerCoordinator: ContainerCoordinatorProtocol {
    
    func updateCurrentPage(_ page: ContentPageType) {
        guard page != currentPage else { return }
        
        switch page {
        case .unauthenticated:
            let loginViewController = LoginViewController()
            containerViewController.setCurrentViewController(viewController: loginViewController)
            
        case .authenticated:
            let homeViewController = UINavigationController(rootViewController: HomeViewController())
            containerViewController.setCurrentViewController(viewController: homeViewController)
        }
        
        self.currentPage = page
    }
}
