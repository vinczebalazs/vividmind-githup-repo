//
//  APIClient.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import PromiseKit

extension Thenable {
    
    // MARK: Public Properties
    
    // swiftlint:disable identifier_name
    
    /// Wrapper for `.done` to get rid of the unused result warning, wihout having to write `.cauterize` everywhere.
    /// Useful when errors are already handled by an error handler.
    @discardableResult func _done(on: DispatchQueue? = conf.Q.return, flags: DispatchWorkItemFlags? = nil,
                                  _ body: @escaping (Self.T) throws -> Void) -> PromiseKit.Promise<Void> {
        done(on: on, flags: flags, body)
    }
    
    // swiftlint:enable identifier_name
    
}
