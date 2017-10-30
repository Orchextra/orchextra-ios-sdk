//
//  PostalCodeValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class PostalCodeValidator: RegexValidator {
    
    required init(mandatory: Bool) {
        super.init(regexPattern: "^((0?[1-9]\\d{3})|([1-9]\\d{4}))$", mandatory: mandatory)
    }
    
    required init(mandatory: Bool, custom: String) {
        super.init(mandatory: mandatory, custom: custom)
    }
}
