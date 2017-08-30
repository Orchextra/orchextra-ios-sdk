//
//  ScannerTests.swift
//  Orchextra
//
//  Created by Judith Medina on 29/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Foundation
import GIGLibrary

@testable import Orchextra


class ScannerTests: XCTestCase {

    // MARK: - Attributes
    
    var presenter: ScannerPresenter!
    var scannerViewMock: ScannerVCMock!
    
    // MARK: - Setup methods
    
    override func setUp() {
        super.setUp()
        self.loginViewMock = ScannerVCMock()
        self.presenter = LoginPresenter(
            view: self.loginViewMock,
            loginInteractor: LoginInteractor(
                service: LoginService()
            )
        )
    }
    
    override func tearDown() {
        self.loginViewMock = nil
        self.presenter = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: - Test methods
    


}
