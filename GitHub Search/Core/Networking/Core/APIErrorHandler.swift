//
//  APIErrorHandler.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import PromiseKit
import SwiftyJSON

final class APIErrorHandler {

    // MARK: Static Public Methods
    
    static func handle<T: APIRequest>(_ error: Error, request: T) throws {
        if isNoConnectionError(error) {
            print("No connection!")
            showAlert("No connection")
            throw error
        }
                
        if case let APIClient.Error.httpError(url: _, errorCode: code, body: _) = error {
            switch code {
            case 403:
                print("Rate limit reached.")
                showAlert("Rate limit reached", "You have reached the rate limit imposed by the GitHub API.")
            default:
                break
            }
        }
        
        // Here we could switch over the error and decide if we want to handle it globally here,
        // or pass it on to the original caller (in this case we only do handle no connection errors globally).
        
        log(error, request: request)
        
        // Re-throw the error so it can reach the original caller.
        throw error
    }
    
    static func log<T: APIRequest>(_ error: Error, request: T? = nil) {
        // This would be the appropriate place to log or report the error to some error reporting service,
        // however for the sake of this application we will only print it to the console.
        print(error)
        if let requestBody = request?.body {
            do {
                print("Request body:\n", try JSON(data: requestBody))
            } catch {
                // Avoid confusion that might arise from shadowing the error variable.
                let parsingError = error
                print("Request body is not JSON: ", parsingError)
            }
        }
    }
    
    // MARK: Static Private Methods
    
    static private func isNoConnectionError(_ error: Error) -> Bool {
        let networkErrors: [URLError.Code] = [.notConnectedToInternet, .timedOut, .cannotFindHost,
                                              .cannotConnectToHost, .networkConnectionLost]
        if let urlError = error as? URLError, networkErrors.contains(urlError.code) {
            return true
        }
        return false
    }
    
    static private func showAlert(_ title: String, _ message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        alertController.show()
    }
    
}
