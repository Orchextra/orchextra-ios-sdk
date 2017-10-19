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

public struct CustomField: Codable {
    let key: String
    let label: String
    let type: CustomFieldType
    let value: ValueCodable
    
    enum CodingKeys: String, CodingKey {
        case key
        case label
        case type
        case value
    }
    
    init(key: String, label: String, type: CustomFieldType, value: ValueCodable) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
    
    // MARK: - Encodable Protocol
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.key, forKey: .key)
        try container.encode(self.label, forKey: .label)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.value, forKey: .value)
    }
    
    // MARK: - Decodable Protocol
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        let label = try container.decode(String.self, forKey: .label)
        let type = try container.decode(CustomFieldType.self, forKey: .type)
        let value = try container.decode(ValueCodable.self, forKey: .value)
        
        self.init(
            key: key,
            label: label,
            type: type,
            value: value
        )
    }
}

extension CustomField: Equatable {
    public static func == (lhs: CustomField, rhs: CustomField) -> Bool {
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
