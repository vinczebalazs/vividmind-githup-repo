//
//  APIErrorHandler.swift
//  EGYJEGY
//
//  Created by Balazs Vincze on 2020. 04. 12..
//  Copyright © 2020. HKIR EGYJEGY. All rights reserved.
//

import Foundation
import SwiftyJSON

final class APIErrorHandler: APIErrorHandlerProtocol {
    
    // MARK: Nested Types
    
    private let unhandledErrorCodes = [
        PreviousPurchasesRefundPresenter.Error.productsNotRefundable.rawValue
    ]
    
    // MARK: Public Methods
    
    func handle<T: APIRequest>(_ error: Error, request: T) {
        if isNoConnectionError(error) {
            #warning("Should display a message to the user.")
            print("No connection!")
            return
        }
        
        let message: String
        if let errorCodeString = (error as? APIError)?.errorCodeString, unhandledErrorCodes.contains(errorCodeString) {
            message = "Hiba történt."
        } else {
            #warning("Nem kell az alert messagebe az errort loggolni majd productionben.")
            message = """
            Hiba történt.
            \(error)
            """
        }
        
        AlertController(title: "Hoppá!", message: message).setConfirm("Ok").show()
        log(error, request: request)
    }
    
    func log<T: APIRequest>(_ error: Error, request: T) {
        #warning("Add appropriate error handling and reporting. Reported errors to Crashlytics should contain the request body as well.")
        print(error)
        if let requestBody = request.body {
            do {
                print("Request body:\n", try JSON(data: requestBody))
            } catch {
                print("Could not deserialize data: ", error)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func isNoConnectionError(_ error: Error) -> Bool {
        let networkErrors: [URLError.Code] = [.notConnectedToInternet, .timedOut, .cannotFindHost,
                                              .cannotConnectToHost, .networkConnectionLost]
        if let urlError = error as? URLError, networkErrors.contains(urlError.code) {
            return true
        }
        return false
    }
    
}
