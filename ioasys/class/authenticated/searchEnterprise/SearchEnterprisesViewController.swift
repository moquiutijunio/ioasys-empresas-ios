//
//  SearchEnterprisesViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

final class SearchEnterprisesViewController: BaseTableViewController {
    
    private var searchQueryDisposeBag: DisposeBag!
    private let apiClient = APIClient()
    
    private var enterprisesRequestResponse: RequestResponse<[Enterprise]> = .new {
        didSet { reloadTableView() }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.tintColor = .lightGray
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.backgroundColor = .white
        textFieldInsideUISearchBar?.textColor = .lightGray
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
        addSearchOnNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    private func registerTableView() {
        
        tableView.register(UINib(nibName: EnterpriseTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: EnterpriseTableViewCell.reuseId)
        tableView.register(UINib(nibName: LoadingTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: LoadingTableViewCell.reuseId)
        tableView.register(UINib(nibName: ErrorTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: ErrorTableViewCell.reuseId)
    }
    
    private func addSearchOnNavigationBar() {
        guard let navigationController = navigationController else { return }
        
        let cancelButton = addButtonOnNavigationBar(content: .text(text: NSLocalizedString("cancel", comment: "")), position: .right) {
            navigationController.popViewController(animated: false)
        }
        
        let navigationBarWidth = navigationController.navigationBar.bounds.size.width
        let navigationBarPadding: CGFloat = navigationBarWidth * 0.12
        cancelButton.width = 71
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.textStyleRegular(size: 17)], for: .normal)
        
        let searchBarWidth = navigationBarWidth - cancelButton.width - navigationBarPadding
        searchBar.frame.size.width = searchBarWidth
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    private func goToEnterpriseDetails(with enterprise: Enterprise) {
        let enterpriseDetailsViewController = EnterpriseDetailsViewController(enterprise: enterprise)
        navigationController?.pushViewController(enterpriseDetailsViewController, animated: true)
    }
}
 
// MARK: - UISearchBarDelegate
extension SearchEnterprisesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchEnterprises(with: searchText)
    }
}

// MARK: - API request
extension SearchEnterprisesViewController {
    
    private func searchEnterprises(with query: String) {
        guard !query.isEmpty else {
            enterprisesRequestResponse = .new
            return
        }
        
        searchQueryDisposeBag = DisposeBag()
        
        enterprisesRequestResponse = .loading
        
        apiClient.getEnterprises(query: query)
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                
                switch event {
                case .success(let enterprises):
                    guard let enterprises = enterprises else {
                        self.enterprisesRequestResponse = .failure(NSLocalizedString("generic.error", comment: ""))
                        return
                    }
                    
                    self.enterprisesRequestResponse = .success(enterprises)
                case .error(let error):
                    self.enterprisesRequestResponse = .failure(error.localizedDescription)
                }
            }
            .disposed(by: searchQueryDisposeBag)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension SearchEnterprisesViewController {
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enterprisesRequestResponse {
        case .success(let transactions): return transactions.count
        case .loading, .failure: return 1
        default: return 0
        }
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enterprisesRequestResponse {
        case .success(let enterprises):
            let cell = tableView.dequeueReusableCell(withIdentifier: EnterpriseTableViewCell.reuseId, for: indexPath) as! EnterpriseTableViewCell
            cell.bindIn(viewModel: EnterpriseViewModel(enterprise: enterprises[indexPath.row]))
            return cell
            
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseId, for: indexPath) as! LoadingTableViewCell
            return cell
            
        case .failure(let error):
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as! ErrorTableViewCell
            cell.bindIn(error: error)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .success(let enterprises) = enterprisesRequestResponse {
            goToEnterpriseDetails(with: enterprises[indexPath.row])
        }
    }
}
