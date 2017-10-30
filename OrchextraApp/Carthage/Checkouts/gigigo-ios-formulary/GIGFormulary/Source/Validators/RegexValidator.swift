//
//  RegexValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 5/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class RegexValidator: StringValidator {
    
    var regex: NSRegularExpression?
    
    init(regex: NSRegularExpression, mandatory: Bool) {
        self.regex = regex
        
        super.init(mandatory: mandatory)
    }
    
    init(regexPattern: String?, mandatory: Bool) {
        if regexPattern != nil {
            self.regex = NSRegularExpression(pattern: regexPattern!)
        }        
        
        super.init(mandatory: mandatory)
    }
    
    required init(mandatory: Bool, custom: String) {
        super.init(mandatory: mandatory, custom: custom)
    }
    
    required init(mandatory: Bool) {
        super.init(mandatory: mandatory)
    }
    
    // MARK: Public Method

    override func validate(_ value: Any?) -> Bool {
        if !super.validate(value) {
            return false
        }
        
        if value != nil {
            guard let stringValue = value as? String else { LogWarn("Parse value String Error, return false"); return false }
            
            if stringValue.characters.count == 0 && !self.mandatory {
                return true
            }
            
            guard let regex = self.regex  else { LogWarn("Regex is nil"); return false }
            return regex.matchesString(stringValue)
        } else {
            return true
        }
    }
}
