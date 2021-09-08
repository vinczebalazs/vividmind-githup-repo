//
//  MainViewController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(MainTableViewCell.self), forCellReuseIdentifier: cellID)
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    // MARK: Private Properties
    
    private let presenter = MainPresenter()
    private let cellID = "RepositoryCell"
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.searchTextField.delegate = self
        return searchController
    }()
    private var isLoadingNextPage = false
    
    // MARK: Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GitHub Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: Private Methods
    
    private func performSearch(query: String) {
        tableView.isHidden = true

        let activityIndicator = UIActivityIndicatorView(style: .large)
        view.addSubview(activityIndicator)
        activityIndicator.constrainToCenter(of: view)
        activityIndicator.startAnimating()
        
        presenter.searchRepositories(query: query).ensure {
            activityIndicator.removeFromSuperview()
            self.tableView.isHidden = false
        }._done {
            self.tableView.reloadData()
        }
    }
    
    private func loadNextPage() {
        guard !isLoadingNextPage && presenter.hasNextPage else { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        tableView.tableFooterView = activityIndicator
        
        isLoadingNextPage = true
        
        presenter.loadNextPage().ensure {
            self.isLoadingNextPage = false
            self.tableView.tableFooterView = nil
        }._done {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MainTableViewCell
        cell.repository = presenter.repositories[indexPath.row]
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let webViewVC = WebViewViewController(repository: presenter.repositories[indexPath.row])
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.height + scrollView.contentOffset.y > scrollView.contentSize.height - 6 {
            loadNextPage()
        }
    }
    
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.returnKeyType = searchText.count > 2 ? .search : .done
        searchBar.reloadInputViews()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count > 2 else {
            return
        }
        
        performSearch(query: query)
    }
    
}

// MARK: UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter.clearSearch()
        tableView.reloadData()
        return true
    }
    
}
