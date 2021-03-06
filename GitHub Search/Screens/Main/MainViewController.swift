//
//  MainViewController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit
import Resolver

final class MainViewController: UIViewController {
    
    // MARK: Public Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(MainTableViewCell.self), forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Private Properties
    
    private var presenter: MainPresenterType
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
    
    // MARK: Initializers
    
    init(presenter: MainPresenterType? = nil) {
        self.presenter = presenter ?? Resolver.resolve()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachPresenter()
        
        title = "GitHub Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.constrainToEdges(of: view)
    }
    
    func searchFinished(_ result: Result<Void, Error>) {
        activityIndicator.removeFromSuperview()
        if case .success() = result {
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    func loadNextPageFinished(_ result: Result<Void, Error>) {
        isLoadingNextPage = false
        tableView.tableFooterView = nil
        if case .success() = result {
            tableView.reloadData()
        }
    }
        
    // MARK: Private Methods
    
    private func performSearch(query: String) {
        tableView.isHidden = true

        view.addSubview(activityIndicator)
        activityIndicator.accessibilityIdentifier = "search"
        activityIndicator.constrainToCenter(of: view)
        activityIndicator.startAnimating()
        
        presenter.searchRepositories(query: query)
    }
    
    private func loadNextPage() {
        guard !isLoadingNextPage && presenter.hasNextPage else { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        activityIndicator.accessibilityIdentifier = "nextPage"
        tableView.tableFooterView = activityIndicator
        
        isLoadingNextPage = true
        presenter.loadNextPage()
    }
    
    private func attachPresenter() {
        presenter.onSearchFinished = { [unowned self] in
            searchFinished($0)
        }
        presenter.onLoadNextPageFinished = { [unowned self] in
            loadNextPageFinished($0)
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
