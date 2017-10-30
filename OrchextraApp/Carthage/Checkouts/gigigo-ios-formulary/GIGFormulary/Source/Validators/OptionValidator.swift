//
//  OptionValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 19/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class OptionValidator: Validator {
    
    override func validate(_ value: Any?) -> Bool {
        if !super.validate(value) {
            return false
        }        
        
        if value is Int {
            guard let valueInt = value as? Int else { LogWarn("Parse value Int Error, return false"); return false }

            if valueInt == 0 && !self.mandatory {
                return true
            } else {
                return valueInt == 0 ? false : true
            }
        }
        
        return true
    }
}
