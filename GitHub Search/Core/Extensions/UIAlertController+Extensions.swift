//
//  UIAlertController+Extensions.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

extension UIAlertController {
    
    // MARK: Public Methods
    
    func show() {
        UIApplication.visibleViewController?.present(self, animated: true, completion: nil)
    }
    
}
