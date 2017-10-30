//
//  CustomValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 26/10/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class CustomValidator: RegexValidator {
    
    required init(mandatory: Bool) {
        super.init(mandatory: mandatory)
    }
    
    required init(mandatory: Bool, custom: String) {
        do {
            let regex = try NSRegularExpression(pattern: custom, options: NSRegularExpression.Options.caseInsensitive)
            super.init(regex: regex, mandatory: mandatory)
        } catch {
            super.init(regexPattern: custom, mandatory: mandatory)
        }
    }
}
