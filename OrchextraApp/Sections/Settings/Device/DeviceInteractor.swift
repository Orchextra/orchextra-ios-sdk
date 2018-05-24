//
//  DeviceInteractor.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 18/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol DeviceInteractorInput {
    func bindDevice()
    func set(businessUnits: String)
    func set(tags: String)
}

protocol DeviceInteractorOutput {
    
}

struct DeviceInteractor {
    
    // MARK: - Attributes
    var output: DeviceInteractorOutput?
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
}

extension DeviceInteractor: DeviceInteractorInput {
    func bindDevice() {
        self.orchextra.bindDevice()
    }
    
    func set(businessUnits: String) {
        let businessUnitsProcessed = self.process(businessUnitsString: businessUnits)
        self.orchextra.setDeviceBusinessUnits(businessUnitsProcessed)
    }
    
    func set(tags: String) {
        let tagsProcessed = self.process(tagsString: tags)
        self.orchextra.setDeviceTags(tagsProcessed)
    }
}
