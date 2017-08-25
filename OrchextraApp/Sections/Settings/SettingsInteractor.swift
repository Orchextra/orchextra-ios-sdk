//
//  SettingsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol SettingsInteractorInput {
    func stopOrchextra()
}

protocol SettingsInteractorOutput {
    
}

struct SettingsInteractor {
    
     // MARK: - Attributes
    
    var output: SettingsInteractorOutput?
    let orchextra = Orchextra.shared
}

extension SettingsInteractor: SettingsInteractorInput {
    func stopOrchextra() {
        self.orchextra.stop()
    }
}
