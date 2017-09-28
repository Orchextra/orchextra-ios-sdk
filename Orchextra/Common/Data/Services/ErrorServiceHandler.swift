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
    case internalError                  //(_500_)
    case routeNotFound                  //(_404_)
    case noDatabase                     //(_500_)
    case projectNotFound                //(_404_)
    case invalidCredentials             //(_403_)
    case unauthorized                   //(_401_)
    case invalidJSON                    //(_400_)
    case validationError                //(_400_)
    
    case ErrorBinding
    
    case unknown
}

class ErrorServiceHandler {
    
    class func parseErrorService(with response: Response) -> Error {
        switch response.statusCode {
        case 1000, 1100:
            return ErrorService.internalError
        case 1002:
            return ErrorService.routeNotFound
        case 1100:
            return ErrorService.noDatabase
        case 2000:
            return ErrorService.projectNotFound
        case 2001:
            return ErrorService.invalidCredentials
        case 2002:
            return ErrorService.unauthorized
        case 2003:
            return ErrorService.invalidJSON
        case 3000:
            return ErrorService.validationError
        default:
            return ErrorService.unknown
        }
    }
    
    class func orxError(with error: Error) {
        
    }
}
