//
//  PhoneValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class PhoneValidator: RegexValidator {
    required init(mandatory: Bool) {
        super.init(regexPattern: "^(\\+\\d{1,3})?\\d{9}$", mandatory: mandatory)
    }
        
    required init(mandatory: Bool, custom: String) {
        super.init(mandatory: mandatory, custom: custom)
    }
}
