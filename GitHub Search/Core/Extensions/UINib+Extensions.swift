//
//  Thenable+Extensions.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import UIKit

extension UINib {
    
    // MARK: Initializers
    
    convenience init<T: UIView>(_ view: T.Type) {
        self.init(nibName: String(describing: view), bundle: nil)
    }
    
}
