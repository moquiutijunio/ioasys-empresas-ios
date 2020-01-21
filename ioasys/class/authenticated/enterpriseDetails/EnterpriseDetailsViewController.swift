//
//  EnterpriseDetailsViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

final class EnterpriseDetailsViewController: BaseTableViewController {

    private var enterpriseDetailsDisposeBag: DisposeBag!
    private let apiClient = APIClient()
    private var enterprise: Enterprise
    
    init(enterprise: Enterprise) {
        self.enterprise = enterprise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyLayout()
        registerTableView()
        getEnterpriseDetails()
    }
    
    private func applyLayout() {
        
        title = enterprise.name
        view.backgroundColor = .white
        
        addButtonOnNavigationBar(content: .image(image: UIImage(named: "ic_search")!), position: .right) { [unowned self] in
            self.goToSearchEnterprises()
        }
    }
    
    private func registerTableView() {
        
        tableView.register(UINib(nibName: EnterpriseDetailsTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: EnterpriseDetailsTableViewCell.reuseId)
    }
    
    private func goToSearchEnterprises() {
        let searchEnterprisesViewController = SearchEnterprisesViewController()
        navigationController?.pushViewController(searchEnterprisesViewController, animated: false)
    }
}

// MARK: - API request
extension EnterpriseDetailsViewController {
    
    private func getEnterpriseDetails() {
        enterpriseDetailsDisposeBag = DisposeBag()
        
        apiClient.getEnterpriseDetails(id: enterprise.id)
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                
                switch event {
                case .success(let enterprise):
                    guard let enterprise = enterprise else { return }
                    self.enterprise = enterprise
                    self.reloadTableView()
                default:
                    break
                }
            }
            .disposed(by: enterpriseDetailsDisposeBag)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension EnterpriseDetailsViewController {
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EnterpriseDetailsTableViewCell.reuseId, for: indexPath) as! EnterpriseDetailsTableViewCell
        cell.bindIn(viewModel: EnterpriseDetailsViewModel(enterprise: enterprise))
        return cell
    }
}
