//
//  FormControllerOutputMock.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 10/4/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary
@testable import GIGFormulary

class FormControllerOutputMock: PFormController {

    var recoverFormModelSpy = false
    var userDidTapLinkSpy = false
    var fieldFocusSpy = false
    var invalidFormSpy = false
    
    // OutPut
    var formValuesOutput: [AnyHashable: Any]?
    
    func recoverFormModel(_ formValues: [AnyHashable: Any]) {
        self.recoverFormModelSpy = true
        self.formValuesOutput = formValues
    }
    
    func userDidTapLink(_ key: String) {
        self.recoverFormModelSpy = true
    }
    
    func fieldFocus(frame: CGRect, key: String?) {
        self.fieldFocusSpy = true
    }
    
    func invalidForm() {
        self.invalidFormSpy = true
    }
}
