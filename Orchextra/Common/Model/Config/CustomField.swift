//
//  CustomField.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

public struct ValueCodable: Any, Codable {}

public enum CustomFieldType: String {
    case string
    case boolean
    case integer
    case float
    case datetime
}

public class CustomField: Codable {
    
    public var key: String
    public var label: String
    public var value: String?
    public var type: CustomFieldType?
    
    public init(key: String, label: String, type: CustomFieldType, value: String?) {
        self.key = key
        self.label = label
        self.type = type
        self.value = value
    }
    
    class func parse(customFieldsList: [String: Any]?) -> [CustomField] {
        
        guard let customFields = customFieldsList else { return [CustomField]() }
        let result = customFields.keys.compactMap { key in
            return CustomField.customFieldFromJSON(key: key, json: customFields)
        }
        return result
    }
    
    class func customFieldFromJSON(key: String, json: [String: Any]) -> CustomField? {
        guard let customFieldProject = Session.shared.project?.customFields else {
            LogDebug("There aren't custom fields setup in the project")
            return nil}
        
        let customField = customFieldProject.filter { return $0.key == key }
        let customFieldUpdated = customField.first
        customFieldUpdated?.value = json[key] as? String
        return customFieldUpdated
    }
    
    class func customField(key: String, json: [String: Any]) -> CustomField? {
       
        guard let type = json["type"] as? String,
             let label = json["label"] as? String else { return nil }
        
        return  CustomField(
            key: key,
            label: label,
            type: self.convertType(value: type),
            value: nil)
    }

    private class func convertType(value: String) -> CustomFieldType {
        switch value {
        case "string":
            return .string
        case "boolean":
            return .boolean
        case "integer":
            return .integer
        case "float":
            return .float
        case "datetime":
            return .datetime
        default:
            return .string
        }
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

extension CustomField {
    
    static func analyticsConsent(withValue value: Bool) -> CustomField {
        return CustomField(
            key: "consent_analytics",
            label: "consent_analytics",
            type: .boolean,
            value: "\(value)"
        )
    }
}
