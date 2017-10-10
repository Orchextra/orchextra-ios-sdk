//
//  CustomField.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct ValueCodable: Any, Codable {}

extension ValueCodable: Equatable {
    static func == (lhs: ValueCodable, rhs: ValueCodable) -> Bool {
        if lhs == rhs {
            return true
        } else {
            return false
        }
    }
}

enum CustomFieldType: String {
    case string
    case boolean
    case integer
    case float
    case datetime
}

struct CustomField: Codable {
    let key: String
    let label: String
    let type: CustomFieldType
    let value: ValueCodable
    
    init(key: String, label: String, type: CustomFieldType, value: ValueCodable) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
}

extension CustomField: Equatable {
    static func == (lhs: CustomField, rhs: CustomField) -> Bool {
        if lhs.key == rhs.key,
             lhs.label == rhs.label,
             lhs.type == rhs.type,
             lhs.value == rhs.value {
                return true
        } else {
            return false
        }
    }
}

extension CustomFieldType: Codable {}
