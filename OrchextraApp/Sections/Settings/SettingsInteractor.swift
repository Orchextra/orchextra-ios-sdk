//
//  SettingsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol SettingsInteractorInput {
    func stopOrchextra()
    func loadProjectName() -> String?
    func loadApiKey() -> String?
    func loadApiSecret() -> String?
}

protocol SettingsInteractorOutput {
    
}

struct SettingsInteractor {
    
     // MARK: - Attributes
    
    var output: SettingsInteractorOutput?
}

extension SettingsInteractor: SettingsInteractorInput {
    func stopOrchextra() {
        OrchextraWrapper.shared.stop()
    }
    
    func loadProjectName() -> String? {
        return nil // TODO: it could be provided by Backend?
    }
    
    func loadApiKey() -> String? {
        return nil //TODO: Provide a method in Core SDK to return it
    }
    
    func loadApiSecret() -> String? {
        return nil //TODO: Provide a method in Core SDK to return it
    }
}
