//
//  User.swift
//  Orchextra
//
//  Created by Judith Medina on 25/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

public enum Gender: String {
    case none
    case male
    case female
}

extension Gender: Codable {}

public struct User: Codable {
    // MARK: - Attributes
    public var crmId: String?
    public var gender: Gender
    public var birthday: Date?
    public var name: String?
    public var surname: String?
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
     init() {
        self.crmId = nil
        self.gender = .none
        self.birthday = nil
        self.name = nil
        self.surname = nil
        self.tags = [Tag]()
        self.businessUnits = [BusinessUnit]()
        self.customFields = [CustomField]()
    }
    
    init(crmId: String, gender: Gender, birthday: Date, tags: [Tag], businessUnits: [BusinessUnit], customFields: [CustomField]) {
        self.crmId = crmId
        self.gender = gender
        self.birthday = birthday
        self.tags = tags
        self.businessUnits = businessUnits
        self.customFields = customFields
    }
    
    // MARK: - Encodable Protocol
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.crmId, forKey: .crmId)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.birthday, forKey: .birthday)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.businessUnits, forKey: .businessUnits)
        try container.encode(self.customFields, forKey: .customFields)
    }
    
    // MARK: - Decodable Protocol
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let crmId = try container.decode(String.self, forKey: .crmId)
        let gender = try container.decode(Gender.self, forKey: .gender)
        let birthday = try container.decode(Date.self, forKey: .birthday)
        let tags = try container.decode([Tag].self, forKey: .tags)
        let businessUnits = try container.decode([BusinessUnit].self, forKey: .businessUnits)
        let customFields = try container.decode([CustomField].self, forKey: .customFields)
        
        self.init(
            crmId: crmId,
            gender: gender,
            birthday: birthday,
            tags: tags,
            businessUnits: businessUnits,
            customFields: customFields
        )
    }
    
    // MARK: - Params
    func userParams() -> [String: Any] {
        let params =
            ["crm":
                ["crmId": self.crmId ?? "",
                 "gender": self.gender,
                 "birthday": self.birthday ?? "",
                 "businessUnits": self.businessUnits,
                 "tags": self.tags,
                 "customFields": self.customFields]]
        
        return params
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
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
