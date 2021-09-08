//
//  UIView+Extensions.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import UIKit

extension UIView {
    
    // MARK: Public Methods
    
    func constrainToEdges(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            leftAnchor.constraint(equalTo: view.leftAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func constrainToCenter(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
