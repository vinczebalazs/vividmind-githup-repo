//
//  Injection.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 09..
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        register {
            (UIApplication.isUITesting ? MainPresenterMock() : MainPresenter()) as MainPresenterType
        }
    }
    
}
