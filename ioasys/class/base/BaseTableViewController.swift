//
//  BaseTableViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

class BaseTableViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.alwaysBounceVertical = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        addTableView()
    }
    
    private func addTableView() {
        
        view.addSubview(tableView)
        constrain(view, tableView) { (view, tableView) in
            tableView.left == view.left
            tableView.right == view.right
            tableView.top == view.safeAreaLayoutGuide.top
            tableView.bottom == view.safeAreaLayoutGuide.bottom
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
