//
//  ErrorServiceHandler.swift
//  Orchextra
//
//  Created by Judith Medina on 16/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary


/// Enum with errors from service connection
///
/// - notInternetConnection:
/// - refreshAccessToken:
/// - invalidCredentials:
/// - errorParsingJson:
/// - unknown:
public enum ErrorService: Error {
    
    case notInternetConnection
    case refreshAccessToken
    case invalidCredentials(message: String)
    case errorParsingJson(element: String)
    case unknown
    
}

class ErrorServiceHandler {
    
    class func parseErrorService(with response: Response) -> Error {
        switch response.statusCode {
        case 403:
            let message: String = response.error?.userInfo["GIGNETWORK_ERROR_MESSAGE"] as? String ?? "No message"
            return ErrorService.invalidCredentials(message: message)
            
        case 401:
            return ErrorService.refreshAccessToken
        default:
            return ErrorService.unknown
        }
    }
}
