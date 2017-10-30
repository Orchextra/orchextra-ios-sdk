//
//  UserPresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation
import Orchextra

protocol UserGenderPresenterInput {
     func userDidSet(gender: String)
}

protocol UserPresenterInput {
    func userDidTapSend(with formValues: [AnyHashable: Any])
    func saveButtonTapped()
}

protocol UserUI: class {
    func showForm(listItems: [[AnyHashable: Any]])
}

class  UserPresenter {
    
    // MARK: - Public attributes
    
    let view: UserUI
    let wireframe: UserWireframe
    let interactor: UserInteractorInput
    let orchextra = Orchextra.shared
    
    var availableCustomFields = [CustomField]()
    var listItems = [[AnyHashable: Any]]()
    
    init(view: UserUI, wireframe: UserWireframe, interactor: UserInteractor) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
    }
    
    // MARK: - Input methods
    func viewDidLoad() {
        
        let user = orchextra.currentUser()
        self.listItems = self.basicItemUser()

        let customFields = orchextra.getAvailableCustomFields()
        self.availableCustomFields = customFields

        for customField in customFields {
            let item = self.item(customField: customField)
            self.listItems.append(item)
        }
        
        self.view.showForm(listItems: self.listItems)
    }
    
    func basicItemUser() -> [[AnyHashable: Any]] {
        let crmId = ["key": "crmID",
                     "type": "text",
                     "label": "Crm Id",
                     "style": [
                        "styleCell": "line",
                        "mandatoryIcon": "mandatory_JR"],
                     "mandatory": false] as [String: Any]
        
        let birthday = ["key": "birthday",
                        "type": "datePicker",
                        "label": "Birthday",
                        "style": [
                            "styleCell": "line",
                            "mandatoryIcon": "mandatory_JR"],
                        "mandatory": false] as [String: Any]
        
        let gender = ["key": "gender",
                      "type": "picker",
                      "label": "Gender",
                      "listOptions": [
                        ["key": "female",
                         "value": "Female"]
                        ,
                        ["key": "male",
                         "value": "Male"]],
                      "style": [
                        "styleCell": "line",
                        "mandatoryIcon": "mandatory_JR"],
                      "mandatory": false] as [String: Any]
        
        let split = ["key": "split_customfield",
                     "type": "index",
                     "label": "Custom Fields",
                     "style": [
                        "sizeTitle": 30,
                        "align": "alignCenter"
            ]] as [String: Any]
        return [crmId, birthday, gender, split]
    }
    
    func item(customField: CustomField) -> [AnyHashable: Any] {
        let item = ["key": "customField_\(customField.key)",
            "type": "text",
            "label": customField.label,
            "value": customField.value ?? "",
            "style": [
                "styleCell": "line",
                "mandatoryIcon": "mandatory_JR"],
            "mandatory": false] as [String: Any]
        
        return item
    }
}

extension UserPresenter: UserPresenterInput {

    func userDidTapSend(with formValues: [AnyHashable: Any]) {
        self.interactor.set(values: formValues)
    }
    
    func saveButtonTapped() {
       self.interactor.performBindOrUnbindOperation()
    }
}
