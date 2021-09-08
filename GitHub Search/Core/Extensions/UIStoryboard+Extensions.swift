//
//  UIStoryboard+Extensions.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

extension UIStoryboard {
    
    // MARK: Public Methods
    
    func loadViewController<T: UIViewController>(_ identifeir: String) -> T {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifeir) as! T
    }
    
}
