//
//  CustomField.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

enum CustomFieldType{
    
}

struct CustomField {
 
    let key: String
    let label: String
    let type: CustomFieldType
    let value: Any
    
//    init(json: [String: Any], key: String) {
//        
//    }
    
    init(key: String, label: String, type: CustomFieldType, value: Any) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
}
