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
    func userDidTapGenderView()
    func userDidTapBirthdateView()
    func userDidSet(crmId: String)
    func userDidSet(birthDate: String)
    func userDidSet(tags: String)
    func userDidSet(businessUnits: String)
    func userDidSet(customFields: String)
    func saveButtonTapped()
}

protocol UserUI: class {
    func updateCell(listItems: [ListItem])
}

class  UserPresenter {
    
    // MARK: - Public attributes
    
    let view: UserUI
    let wireframe: UserWireframe
    let interactor: UserInteractorInput
    
    var availableCustomFields = [CustomField]()
    var listItems = [ListItem]()
    
    init(view: UserUI, wireframe: UserWireframe, interactor: UserInteractor) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
    }
    
    // MARK: - Input methods
    func viewDidLoad() {
        
        let orchextra = Orchextra.shared
        
        let user = orchextra.currentUser()
        let crmIDItem = ListItem(key: "CrmId", value: user?.crmId)
        let birthDayItem = ListItem(key: "Birthday", value: user?.birthday?.description)
        let genderItem = ListItem(key: "Birthday", value: user?.gender.rawValue)

        self.listItems.append(crmIDItem)
        self.listItems.append(birthDayItem)
        self.listItems.append(genderItem)

        let customFields = orchextra.getAvailableCustomFields()
        self.availableCustomFields = customFields

        for customField in customFields {
            let item = ListItem(from: customField)
            self.listItems.append(item)
        }
        
        self.view.updateCell(listItems: self.listItems)
    }
}

extension UserPresenter: UserPresenterInput {
    func userDidTapGenderView() {
        // TODO: Show Gender picker
    }
    
    func userDidTapBirthdateView() {
        // TODO: Show Date picker
    }
    
    func userDidSet(crmId: String) {
        self.interactor.set(crmId: crmId)
    }
    
    func userDidSet(birthDate: String) {
        self.interactor.set(birthDate: birthDate)
    }
    
    func userDidSet(tags: String) {
        self.interactor.set(tags: tags)
    }
    
    func userDidSet(businessUnits: String) {
        self.interactor.set(businessUnits: businessUnits)
    }
    
    func userDidSet(customFields: String) {
        self.interactor.set(customFields: customFields)
    }
    
    func saveButtonTapped() {
       self.interactor.performBindOrUnbindOperation()
    }
}

extension UserPresenter: UserGenderPresenterInput {
    func userDidSet(gender: String) {
        self.interactor.set(gender: gender)
    }
}

struct ListItem {
    var key: String
    var value: String?
    
    init(key: String, value: String?) {
        self.key = key
        self.value = value
    }
    
    init(from customField: CustomField) {
        self.key = customField.key
        self.value = customField.value
    }
}
