//
//  WebViewViewController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let webView = WKWebView()
    private let repository: Repository
    
    // MARK: Initializers
    
    init(repository: Repository) {
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        title = repository.name
        view.addSubview(webView)
        webView.constrainToEdges(of: view)
        webView.load(URLRequest(url: repository.htmlURL))
    }
    
}
