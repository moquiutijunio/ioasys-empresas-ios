//
//  HomeViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

final class HomeViewController: BaseViewController {

    private lazy var searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.numberOfLines = 0
        searchLabel.font = .textStyle6
        searchLabel.textAlignment = .center
        searchLabel.text = NSLocalizedString("home.text", comment: "")
        searchLabel.textColor = UIColor(named: "charcoal_grey")
        return searchLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        applyLayout()
        addSubviews()
    }
    
    private func applyLayout() {
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_white"))
        addButtonOnNavigationBar(content: .image(image: UIImage(named: "ic_search")!), position: .right) { [unowned self] in
            self.goToSearchEnterprise()
        }
    }
    
    private func goToSearchEnterprise() {
        let searchEnterpriseViewController = SearchEnterpriseViewController()
        navigationController?.pushViewController(searchEnterpriseViewController, animated: false)
    }
}

// MARK: - Setup view
extension HomeViewController {
    
    private func addSubviews() {
        
        view.addSubview(searchLabel)
        constrain(view, searchLabel) { (container, label) in
            label.left == container.left + 16
            label.right == container.right - 16
            label.center == container.center
        }
    }
}
