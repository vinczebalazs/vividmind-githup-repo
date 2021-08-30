//
//  SearchViewController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let presenter: SearchPresenterType
    
    // MARK: Initializers
    
    init(presenter: SearchPresenterType) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        attachPresenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    
    private func attachPresenter() {
        
    }
    
}
