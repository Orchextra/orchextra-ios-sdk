//
//  User.swift
//  Orchextra
//
//  Created by Judith Medina on 25/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

public enum Gender: String {
    case none
    case male = "m"
    case female = "f"
}

extension Gender: Codable {}

public class UserOrx: Codable {
    // MARK: - Attributes
    public var crmId: String?
    public var gender: Gender
    public var birthday: Date?
    public var tags: [Tag]
    public var businessUnits: [BusinessUnit]
    public var customFields: [CustomField]
    
    enum CodingKeys: String, CodingKey {
        case crmId
        case gender
        case birthday
        case tags
        case businessUnits
        case customFields
    }

    // MARK: - Initializers
    public init() {
        self.gender = .none
        self.tags = [Tag]()
        self.businessUnits = [BusinessUnit]()
        self.customFields = [CustomField]()
    }
    
    public init(crmId: String, gender: Gender, birthday: Date, tags: [Tag], businessUnits: [BusinessUnit], customFields: [CustomField]) {
        self.crmId = crmId
        self.gender = gender
        self.birthday = birthday
        self.tags = tags
        self.businessUnits = businessUnits
        self.customFields = customFields
    }
    
    // MARK: - Params
    func userParams() -> [String: Any]? {
        guard let crmId = self.crmId else {
            LogDebug("User does not have CRMID we cannot do a bind user")
            return nil
        }
        
        var params = [String: Any]()
        params["crmId"] = crmId
        if let birthDate = self.birthday?.description {
            params["birthDate"] = birthDate
        }
        params["gender"] = self.gender.rawValue
        params["businessUnits"] = self.businessParam()
        params["tags"] = self.tagsParam()
        params["customFields"] = self.customFieldsParam()
        return ["crm": params]
    }
    
    // MARK: - Private
    
    private func businessParam() -> [String] {
        var business = [String]()
        for businessUnit in self.businessUnits {
            business.append(businessUnit.name)
        }
        return business
    }
    
    private func tagsParam() -> [String] {
        var tags = [String]()
        for tag in self.tags {
            if let tagString = tag.tag() {
                tags.append(tagString)
            }
        }
        return tags
    }
    
    private func customFieldsParam() -> [String: Any] {
        var customFieldsParam = [String: Any]()
        for customField in self.customFields {
            customFieldsParam[customField.key] = customField.value
        }
        return customFieldsParam
    }
}

extension UserOrx: Equatable {
    public static func == (lhs: UserOrx, rhs: UserOrx) -> Bool {
        if lhs.crmId == rhs.crmId,
        lhs.gender == rhs.gender,
        lhs.birthday == rhs.birthday,
        lhs.tags == rhs.tags,
        lhs.businessUnits == rhs.businessUnits,
        lhs.customFields == rhs.customFields {
            return true
        } else {
            return false
        }
    }
}
