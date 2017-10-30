//
//  MailValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 5/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class MailValidator: RegexValidator {
    
    required init(mandatory: Bool) {
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            super.init(regex: regex, mandatory: mandatory)
        } catch {
            super.init(regexPattern: pattern, mandatory: mandatory)
        }
    }    
    
    required init(mandatory: Bool, custom: String) {
        super.init(mandatory: mandatory, custom: custom)
    }
}
