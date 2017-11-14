//
//  DevicePresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation
import Orchextra

protocol DevicePresenterInput {
    func userDidTappedSave(tags: String?, businessUnit: String?)
}

protocol DeviceUI: class {
    func showDevice(tags: String)
    func showDevice(businessUnit: String)
}

struct DevicePresenter {
    
    // MARK: - Public attributes
    
    weak var view: DeviceUI?
    let wireframe: DeviceWireframe
    let interactor: DeviceInteractorInput
    let orchextra = Orchextra.shared

    
    // MARK: - Input methods
    func viewDidLoad() {
        
        let deviceTags = orchextra.getDeviceTags()
        var tagsField = ""
        for tagField in deviceTags {
            if let item = tagField.tag() {
                tagsField = self.concatenate(text: tagsField, item: item)
            }
        }
        self.view?.showDevice(tags: tagsField)
        
        let businessUnitDevice = orchextra.getDeviceBusinessUnits()
        var businessUnitsField = ""
        for businessUnitField in businessUnitDevice {
            businessUnitsField = self.concatenate(text: businessUnitsField, item: businessUnitField.name)
        }
        self.view?.showDevice(businessUnit: businessUnitsField)
    }
    
    func concatenate(text: String, item: String) -> String {
        var result = text
        result = text.isEmpty ? "\(item)" : "\(text), \(item)"
        return result
    }

}

extension DevicePresenter: DevicePresenterInput {
    
    func userDidTappedSave(tags: String?, businessUnit: String?) {
        if let tagsDevice = tags {
            self.interactor.set(tags: tagsDevice)
        }
        if let businessDevice = businessUnit {
            self.interactor.set(businessUnits: businessDevice)
        }
        self.orchextra.bindDevice()
    }
}
