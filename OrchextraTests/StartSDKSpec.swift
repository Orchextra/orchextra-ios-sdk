//
//  StartSDKSpec.swift
//  OrchextraTests
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Nimble
import Quick
import GIGLibrary
import OHHTTPStubs
@testable import Orchextra

class StartSDKSpec: QuickSpec {
    
    var apiKey = "API_KEY_TEST"
    var apiSecret = "API_SECRET_TEST"
    
    var orchextra: Orchextra!
  
    override func spec() {
        
        beforeEach {
            self.orchextra = Orchextra.shared
        }
        
        describe("orchextra start") {
            
            context("when apikey or apisecret are empty") {
                
                self.apiKey = ""
                self.apiSecret = ""
                
                fit("return credentials error") {
                    var resultExpected: ErrorService?
                    self.orchextra.start(with: self.apiKey, apiSecret: self.apiSecret, completion: { result in
                        switch result {
                        case .error(let error):
                            resultExpected = error as? ErrorService
                        default:
                            resultExpected = nil
                        }
                    })
                    expect(resultExpected).toEventually(equal(ErrorService.invalidCredentials))
                }
            }
        }
    }
    

    
}
