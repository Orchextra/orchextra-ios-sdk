//
//  UserInteractor.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 18/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol UserInteractorInput {
    func set(values: [AnyHashable: Any], customFields: [CustomField])
    func performBindOrUnbindOperation()
    func unBindUser()
}

protocol UserInteractorOutput {
    
}

struct UserInteractor {
    // MARK: - Attributes
    var output: UserInteractorOutput?
    let orchextra = Orchextra.shared
    
    // MARK: - Private methods
    fileprivate func process(businessUnitsString: String) -> [BusinessUnit] {
        let businessUnitLists: [String] = businessUnitsString.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
        let businessUnits: [BusinessUnit] = BusinessUnit.parse(businessUnitList: businessUnitLists)
        return businessUnits
    }
    
    fileprivate func process(tagsString: String) -> [Tag] {
        let tagsList: [String] = tagsString.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
        let tags: [Tag] = Tag.parse(tagsList: tagsList)
        return tags
    }
    
    fileprivate func process(gender: String) -> Gender {
        var result: Gender = .none
        switch gender {
        case "male":
            result = .male
        case "female":
            result = .female
        default:
            result = .none
        }
        return result
    }
    
    func proccess(birthDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"        
        return dateFormatter.date(from: birthDate)
    }
}

extension UserInteractor: UserInteractorInput {

    func set(values: [AnyHashable: Any], customFields: [CustomField]) {
        
        var user: UserOrx

        if let currentUser = self.orchextra.currentUser() {
            user = currentUser
        } else {
            user = UserOrx()
        }

        if let crmID = values["crmID"] as? String {
            user.crmId = crmID
        }

        if let gender = values["gender"] as? String {
            user.gender = self.process(gender: gender)
        }

        if let birthday = values["birthday"] as? String {
            user.birthday = self.proccess(birthDate: birthday)
        }
        
        for customField in customFields {
            if let value = values["customField_\(customField.key)"] as? String {
                customField.value = value
            }
        }
        user.customFields = customFields
        
        if let tags = values["tags"] as? String {
            let tagsItems = self.process(tagsString: tags)
            user.tags = tagsItems
        }
        
        if let businessUnits = values["businessUnits"] as? String {
            let businessUnitsItems = self.process(businessUnitsString: businessUnits)
            user.businessUnits = businessUnitsItems
        }
    
        self.bind(user: user)
    }
    
    func performBindOrUnbindOperation() {
        guard let currentUser = self.orchextra.currentUser() else { return }
        if currentUser.crmId == nil {
            self.unBindUser()
        } else {
            self.bind(user: currentUser)
        }
    }
    
    func bind(user: UserOrx) {
        self.orchextra.bindUser(user)
    }
    
    func unBindUser() {
       self.orchextra.unbindUser()
    }
}
