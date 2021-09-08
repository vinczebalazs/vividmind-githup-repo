//
//  UIApplication+Extensions.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

extension UIApplication {
    
    // MARK: Static Public Properties
    
    static var window: UIWindow? {
       (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    static var rootViewController: UIViewController? {
        window?.rootViewController
    }
    
    static var visibleViewController: UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.presentedViewController ??
                navigationController.topViewController ?? navigationController
        } else if let tabBarController = rootViewController as? UITabBarController {
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                return navigationController.presentedViewController ??
                    navigationController.topViewController ??
                    navigationController
            }
            return tabBarController.selectedViewController ?? tabBarController
        } else {
            return rootViewController
        }
    }
    
}
