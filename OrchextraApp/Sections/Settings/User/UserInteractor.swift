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
    func set(crmId: String)
    func set(gender: String)
    func set(birthDate: String)
    func set(tags: String)
    func set(businessUnits: String)
    func set(customFields: String)
    func set(name: String)
    func set(surname: String)
    func performBindOrUnbindOperation()
    func bind(user: User)
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
        
        let businessUnits: [BusinessUnit] = businessUnitLists.map { BusinessUnit(name: $0) }
        
        return businessUnits
    }
    
    fileprivate func process(tagsString: String) -> [Tag] {
        let tagsList: [String] = tagsString.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
        
        let tags: [Tag] = tagsList.map { Tag(prefix: $0) }
        
        return tags
    }
    
    fileprivate func process(customFieldsString: String) -> [CustomField] {
        // To update a custom field value is neccessary to know its key and that key must be a valid one.
//        let customFieldsList: [String] = customFieldsString.trimmingCharacters(in: .whitespacesAndNewlines)
//            .components(separatedBy: ",")
//        // TODO: Modify this method according to set custom fields selection
//        let customFields: [CustomField] = customFieldsList.map {
//            let parameter = $0
//            CustomField(key: "", label: "", type: .string, value: ValueCodable()) }
//
//        return customFields
        return [CustomField]()
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
}

extension UserInteractor: UserInteractorInput {
    // TODO: Perform bind/unbind only when save button is tapped?????? Do make it sense to have a save button?
    func set(crmId: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.crmId = crmId
        self.bind(user: currentUser)
    }
    
    func set(gender: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.gender = self.process(gender: gender)
        self.bind(user: currentUser)
    }
    
    func set(birthDate: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.birthday = DateFormatter().date(from: birthDate)
        self.bind(user: currentUser)
    }
    
    func set(tags: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.tags = self.process(tagsString: tags)
        self.bind(user: currentUser)
    }
    
    func set(businessUnits: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.businessUnits = self.process(businessUnitsString: businessUnits)
        self.bind(user: currentUser)
    }
    
    func set(customFields: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.customFields = self.process(customFieldsString: customFields)
        self.bind(user: currentUser)
    }
    // TODO: NAME AND SURNAME COULD BE NOT NECESSARY!!
    func set(name: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.name = name
        self.bind(user: currentUser)
    }
    
    func set(surname: String) {
        guard var currentUser = self.orchextra.currentUser() else { return }
        currentUser.surname = surname
        self.bind(user: currentUser)
    }
    
    func performBindOrUnbindOperation() {
        guard let currentUser = self.orchextra.currentUser() else { return }
        if currentUser.crmId == nil {
            self.unBindUser()
        } else {
            self.bind(user: currentUser)
        }
    }
    
    func bind(user: User) {
        self.bind(user: user)
    }
    
    func unBindUser() {
       self.orchextra.unbindUser()
    }
}