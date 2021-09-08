//
//  MainViewController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let presenter: MainPresenter
    
    // MARK: Initializers
    
    init(presenter: MainPresenter) {
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
