//
//  User.swift
//  Orchextra
//
//  Created by Judith Medina on 25/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

enum Gender: String {
    case none
    case male
    case female
}

extension Gender: Codable {}

public struct User: Codable {
    // MARK: - Attributes
    let crmId: String?
    let gender: Gender
    let birthday: Date?
    let tags: [Tag]
    let businessUnits: [BusinessUnit]
    let customFields: [CustomField]

    // MARK: - Initializers
     init() {
        self.crmId = nil
        self.gender = .none
        self.birthday = nil
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
