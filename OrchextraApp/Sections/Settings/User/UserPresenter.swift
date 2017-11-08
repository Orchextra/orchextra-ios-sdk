//
//  UserPresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation
import Orchextra

protocol UserPresenterInput {
    func userDidTapSend(with formValues: [AnyHashable: Any])
    func saveButtonTapped()
}

protocol UserUI: class {
    func populate(items: [AnyHashable: Any])
    func showForm(listItems: [[AnyHashable: Any]])
}

class  UserPresenter {
    
    // MARK: - Public attributes
    
    let view: UserUI
    let wireframe: UserWireframe
    let interactor: UserInteractorInput
    let orchextra = Orchextra.shared
    
    var availableCustomFields = [CustomField]()
    var userTags = [Tag]()
    var listItems = [[AnyHashable: Any]]()
    
    init(view: UserUI, wireframe: UserWireframe, interactor: UserInteractor) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
    }
    
    // MARK: - Input methods
    func viewDidLoad() {
        
        self.listItems = self.crmItemUser()
        let customFields = orchextra.getAvailableCustomFields()
        self.availableCustomFields = customFields
        
        for customField in customFields {
            let item = self.item(customField: customField)
            self.listItems.append(item)
        }
       
        self.view.showForm(listItems: self.listItems)
        self.view.populate(items: self.populate()) 
    }
    
    func populate() -> [String: Any] {
        
        var populateItems = [String: Any]()
        let user = orchextra.currentUser()
        
        // CRMID
        if let crmid = user?.crmId {
            populateItems["crmID"] = crmid
        }
        
        // BIRTHDAY
        if let birthday = user?.birthday {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
            populateItems["birthday"] = formatter.string(from: birthday)
        }
        
        // GENDER
        if let gender = user?.gender {
            switch gender {
            case .female:
                populateItems["gender"] = "female"
            case .male:
                populateItems["gender"] = "male"
            case .none:
                populateItems["gender"] = "male"
            }
        }
        
        // CUSTOMFIELDS
        let customFieldsUser = orchextra.getCustomFields()
        for customField in customFieldsUser {
            populateItems["customField_\(customField.key)"] = customField.value
        }
        
        // TAGS
        self.userTags = orchextra.getUserTags()
        
        var tagsField = ""
        for tagField in self.userTags {
            if let item = tagField.tag() {
                tagsField += "\(item) "
            }
        }
        populateItems["tags"] = tagsField
        
        return populateItems
    }
    
    func crmItemUser() -> [[AnyHashable: Any]] {
        let crmId = ["key": "crmID",
                     "type": "text",
                     "label": "Crm Id",
                     "placeHolder": "crm Id",
                     "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
                     "mandatory": false] as [String: Any]
        
        let birthday = ["key": "birthday",
                        "type": "datePicker",
                        "label": "Birthday",
                        "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
                        "mandatory": false] as [String: Any]
        
        let gender = ["key": "gender",
                      "type": "picker",
                      "label": "Gender",
                      "listOptions": [
                        ["key": "female", "value": "Female"],
                        ["key": "male", "value": "Male"]],
                      "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
                      "mandatory": false] as [String: Any]
        
        let tags = ["key": "tags",
                    "type": "text",
                    "label": "Tags",
                    "placeHolder": "tags",
                    "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
                    "mandatory": false] as [String: Any]
        
        let split = ["key": "split_customfield",
                     "type": "index",
                     "label": "Custom Fields",
                     "style": ["sizeTitle": 30, "align": "alignCenter"
            ]] as [String: Any]
        return [crmId, birthday, gender, tags, split]
    }
    
    func tagsItems() -> [AnyHashable: Any] {
        
        let tags = ["key": "tags",
                    "type": "text",
                    "label": "Tags",
                    "placeHolder": "tags",
                    "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
                    "mandatory": false] as [String: Any]
        
        return tags
    }
    
    func customFieldsItems() -> [AnyHashable: Any] {
        let split = ["key": "split_customfield",
                     "type": "index",
                     "label": "Custom Fields",
                     "style": ["sizeTitle": 30, "align": "alignCenter"
            ]] as [String: Any]
        
        return split
    }
    
    func item(customField: CustomField) -> [AnyHashable: Any] {
        let item = ["key": "customField_\(customField.key)",
            "type": "text",
            "placeHolder": customField.label,
            "label": customField.label,
            "value": customField.value ?? "",
            "style": ["styleCell": "line", "mandatoryIcon": "mandatory_JR"],
            "mandatory": false] as [String: Any]
        
        return item
    }
}

extension UserPresenter: UserPresenterInput {

    func userDidTapSend(with formValues: [AnyHashable: Any]) {
        self.interactor.set(values: formValues, customFields: self.availableCustomFields)
    }
    
    func saveButtonTapped() {
       self.interactor.performBindOrUnbindOperation()
    }
}
