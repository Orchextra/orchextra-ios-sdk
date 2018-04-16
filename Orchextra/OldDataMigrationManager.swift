//
//  OldDataMigrationManager.swift
//  Orchextra
//
//  Created by José Estela on 12/4/18.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

enum OldOrchextraKeys: String {
    case user = "ORCUserKey"
    case businessUnit = "ORCBusinessUnits"
    case crmId = "ORCCrmId"
    case birthdate = "ORCBirthday"
    case gender = "ORCGender"
    case tags = "ORCTags"
    case customFields = "ORCCustomFields"
    case deviceTags = "ORCDeviceTags"
    case deviceBusinessUnits = "ORCDeviceBusinessUnits"
    case tagPrefix = "ORCTagPrefix"
    case tagName = "ORCTagName"
    case businessUnitName = "ORCBusinessUnitName"
    case key
    case label
    case value
    case type
}

class OldDataMigrationManager {
    
    // MARK: - Private attributes
    
    private let userDefaults: UserDefaults
    private let session: Session
    
    // MARK: - Public methods
    
    init(userDefaults: UserDefaults, session: Session) {
        self.userDefaults = userDefaults
        self.session = session
    }
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.session = Session.shared
    }
    
    func migrateData() {
        self.configure()
        if shouldMigrateData() {
            print("===== STARTING ORX2.0 MIGRATION PROCESS ====")
            if let userData = self.userDefaults.object(forKey: OldOrchextraKeys.user.rawValue) as? Data, let oldUser = NSKeyedUnarchiver.unarchiveObject(with: userData) as? OldUser, let newUser = oldUser.toUser() {
                print("Migrating user")
                self.session.bindUser(newUser)
            }
            if let deviceTags = self.userDefaults.array(forKey: OldOrchextraKeys.deviceTags.rawValue) as? [Data], deviceTags.count > 0 {
                let tags = deviceTags.compactMap({ NSKeyedUnarchiver.unarchiveObject(with: $0) as? OldTag }).map({ $0.toTag() })
                print("Migrating device tags: \(tags)")
                self.session.setDeviceTags(tags: tags)
            }
            if let deviceBusinessUnits = self.userDefaults.array(forKey: OldOrchextraKeys.deviceBusinessUnits.rawValue) as? [Data], deviceBusinessUnits.count > 0 {
                let businessUnits = deviceBusinessUnits.compactMap({ NSKeyedUnarchiver.unarchiveObject(with: $0) as? OldBusinessUnit }).map({ $0.toBusinessUnit() })
                print("Migrating device businessUnits: \(businessUnits.map({ $0.name }))")
                self.session.setDeviceBusinessUnits(businessUnits: businessUnits)
            }
            self.deleteOldData()
            print("===== MIGRATION PROCESS FINISHED ====")
        }
    }
    
    // MARK: - Private methods
    
    private func configure() {
        NSKeyedUnarchiver.setClass(OldUser.classForKeyedUnarchiver(), forClassName: "ORCUser")
        NSKeyedUnarchiver.setClass(OldBusinessUnit.classForKeyedUnarchiver(), forClassName: "ORCBusinessUnit")
        NSKeyedUnarchiver.setClass(OldTag.classForKeyedUnarchiver(), forClassName: "ORCTag")
        NSKeyedUnarchiver.setClass(OldCustomField.classForKeyedUnarchiver(), forClassName: "ORCCustomField")
    }
    
    private func shouldMigrateData() -> Bool {
        return
            self.userDefaults.object(forKey: OldOrchextraKeys.user.rawValue) != nil ||
            self.userDefaults.object(forKey: OldOrchextraKeys.deviceBusinessUnits.rawValue) != nil ||
            self.userDefaults.object(forKey: OldOrchextraKeys.deviceTags.rawValue) != nil
    }
    
    private func deleteOldData() {
        self.userDefaults.removeObject(forKey: OldOrchextraKeys.user.rawValue)
        self.userDefaults.removeObject(forKey: OldOrchextraKeys.deviceTags.rawValue)
        self.userDefaults.removeObject(forKey: OldOrchextraKeys.deviceBusinessUnits.rawValue)
    }
}

@objc(ORCUser)
private class OldUser: NSObject, NSCoding {
    
    let crmId: String?
    let birthdate: Date?
    let gender: Gender
    let tags: [Tag]
    let customFields: [CustomField]
    let businessUnits: [BusinessUnit]
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        // Nothing to do here
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.crmId = aDecoder.decodeObject(forKey: OldOrchextraKeys.crmId.rawValue) as? String
        self.birthdate = aDecoder.decodeObject(forKey: OldOrchextraKeys.birthdate.rawValue) as? Date
        self.tags = (aDecoder.decodeObject(forKey: OldOrchextraKeys.tags.rawValue) as? [OldTag] ?? []).map({ $0.toTag() })
        self.customFields = (aDecoder.decodeObject(forKey: OldOrchextraKeys.customFields.rawValue) as? [OldCustomField] ?? []).map({ $0.toCustomField() })
        self.gender = (aDecoder.decodeObject(forKey: OldOrchextraKeys.gender.rawValue) as? Int).map({
            if $0 == 0 {
                return Gender.none
            } else if $0 == 1 {
                return Gender.female
            }
            return Gender.male
        }) ?? .none
        self.businessUnits = (aDecoder.decodeObject(forKey: OldOrchextraKeys.businessUnit.rawValue) as? [OldBusinessUnit] ?? []).map({ $0.toBusinessUnit() })
    }
    
    // MARK: - Public methods
    
    func toUser() -> UserOrx? {
        guard
            let crmId = self.crmId
        else {
            return nil
        }
        return UserOrx(crmId: crmId, gender: self.gender, birthday: self.birthdate, tags: self.tags, businessUnits: self.businessUnits, customFields: self.customFields)
    }
}

@objc(ORCBusinessUnit)
private class OldBusinessUnit: NSObject, NSCoding {
    
    let name: String
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        // Nothing to do here
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: OldOrchextraKeys.businessUnitName.rawValue) as? String ?? ""
    }
    
    // Public methods
    
    func toBusinessUnit() -> BusinessUnit {
        return BusinessUnit(name: self.name)
    }
}

@objc(ORCTag)
private class OldTag: NSObject, NSCoding {
    
    let name: String?
    let prefix: String
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        // Nothing to do here
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: OldOrchextraKeys.tagName.rawValue) as? String
        self.prefix = aDecoder.decodeObject(forKey: OldOrchextraKeys.tagPrefix.rawValue) as? String ?? ""
    }
    
    // Public methods
    
    func toTag() -> Tag {
        guard let name = self.name else {
            return Tag(prefix: prefix)
        }
        return Tag(prefix: prefix, name: name)
    }
}

@objc(ORCCustomField)
private class OldCustomField: NSObject, NSCoding {
    
    let key: String
    let label: String
    let value: String?
    let type: CustomFieldType
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        // Nothing to do here
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.key = aDecoder.decodeObject(forKey: OldOrchextraKeys.key.rawValue) as? String ?? ""
        self.label = aDecoder.decodeObject(forKey: OldOrchextraKeys.label.rawValue) as? String ?? ""
        self.value = aDecoder.decodeObject(forKey: OldOrchextraKeys.value.rawValue).map {
            if let string = $0 as? String {
                return string
            } else if let integer = $0 as? Int {
                return "\(integer)"
            } else if let float = $0 as? Float {
                return "\(float)"
            } else if let boolean = $0 as? Bool {
                return "\(boolean)"
            } else if let dateTime = $0 as? Date {
                return "\(dateTime.timeIntervalSince1970)"
            }
            return ""
        }
        self.type = (aDecoder.decodeObject(forKey: OldOrchextraKeys.type.rawValue) as? Int).map {
            if $0 == 1 {
                return CustomFieldType.string
            } else if $0 == 2 {
                return CustomFieldType.boolean
            } else if $0 == 3 {
                return CustomFieldType.integer
            } else if $0 == 4 {
                return CustomFieldType.float
            } else if $0 == 5 {
                return CustomFieldType.datetime
            }
            return CustomFieldType.string
        } ?? CustomFieldType.string
    }

    // Public methods
    
    func toCustomField() -> CustomField {
        return CustomField(key: self.key, label: self.label, type: self.type, value: self.value)
    }
}
