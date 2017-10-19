//
//  DeviceInteractor.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 18/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol DeviceInteractorInput {
    func bindDevice()
}

protocol DeviceInteractorOutput {
    
}

struct DeviceInteractor {
    
    // MARK: - Attributes
    var output: DeviceInteractorOutput?
}

extension DeviceInteractor: DeviceInteractorInput {
    func bindDevice() {
        
    }
    
    
}
