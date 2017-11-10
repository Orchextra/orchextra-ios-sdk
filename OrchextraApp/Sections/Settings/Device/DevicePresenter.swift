//
//  DevicePresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation

protocol DevicePresenterInput {
    func userDidSet(tags: String)
    func userDidSet(businessUnits: String)
}

protocol DeviceUI: class {
}

struct DevicePresenter {
    
    // MARK: - Public attributes
    
    weak var view: DeviceUI?
    let wireframe: DeviceWireframe
    let interactor: DeviceInteractorInput
    
    // MARK: - Input methods
    func viewDidLoad() {
    }
}

extension DevicePresenter: DevicePresenterInput {
    func userDidSet(tags: String) {
        self.interactor.set(tags: tags)
    }
    
    func userDidSet(businessUnits: String) {
        self.interactor.set(businessUnits: businessUnits)
    }
}
