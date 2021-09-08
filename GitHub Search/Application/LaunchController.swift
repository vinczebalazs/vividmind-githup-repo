//
//  LaunchController.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

final class LaunchController {
    
    // MARK: Static Private Properties
    
    static private var rootViewController: UIViewController {
        return UINavigationController(rootViewController: MainViewController())
    }
    
    // MARK: Static Public Methods
    
    static func handleLaunch(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
