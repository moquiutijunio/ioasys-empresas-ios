//
//  SearchEnterpriseViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class SearchEnterpriseViewController: BaseViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.tintColor = .lightGray
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.backgroundColor = .white
        textFieldInsideUISearchBar?.textColor = .lightGray
        let clearButton = textFieldInsideUISearchBar?.value(forKey: "_clearButton") as? UIButton
        let imageButton = clearButton?.image(for: .highlighted)?.withRenderingMode(.alwaysTemplate)
        let tintedClearImage = imageButton?.imageWithColor(color1: UIColor(named: "darkish_pink")!)
        clearButton?.setImage(tintedClearImage, for: .normal)
        clearButton?.setImage(tintedClearImage, for: .highlighted)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchOnNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func addSearchOnNavigationBar() {
        guard let navigationController = navigationController else { return }
        
        let cancelButton = addButtonOnNavigationBar(content: .text(text: NSLocalizedString("cancel", comment: "")), position: .right) {
            navigationController.popViewController(animated: false)
        }
        
        let navigationBarWidth = navigationController.navigationBar.bounds.size.width
        let navigationBarPadding: CGFloat = navigationBarWidth * 0.12
        cancelButton.width = 71
        
        let searchBarWidth = navigationBarWidth - cancelButton.width - navigationBarPadding
        searchBar.frame.size.width = searchBarWidth
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = leftNavBarButton
        
        searchBar.placeholder = NSLocalizedString("search", comment: "")
    }
}

// MARK: - UISearchBarDelegate
extension SearchEnterpriseViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

