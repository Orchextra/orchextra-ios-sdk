//
//  UserPresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation

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
}

struct  UserPresenter {
    
    // MARK: - Public attributes
    
    weak var view: UserUI?
    let wireframe: UserWireframe
    let interactor: UserInteractorInput
    
    // MARK: - Input methods
    func viewDidLoad() {
        
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
