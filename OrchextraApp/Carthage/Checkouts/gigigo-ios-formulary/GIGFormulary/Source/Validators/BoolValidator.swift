//
//  BoolValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class BoolValidator: Validator {
    
    override func validate(_ value: Any?) -> Bool {
        if !super.validate(value) {
            return false
        }
        
        if self.mandatory {
            if value is Bool {
                guard let valueBool = value as? Bool else {LogWarn("Parse value Bool Error, return false"); return false }
                return valueBool
            }
        }
        
        return true
    }
}
