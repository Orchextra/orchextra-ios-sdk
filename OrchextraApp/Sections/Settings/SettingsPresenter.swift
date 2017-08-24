//
//  SettingsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol SettingsPresenterInput {
    func viewDidLoad()
    func userDidTapStop()
}

protocol SettingsUI: class {
    
}

struct SettingsPresenter {
        
    // MARK: - Public attributes
    
    weak var view: SettingsUI?
    let wireframe: SettingsWireframe
    
    // MARK: - Interactors
    
    let interactor: SettingsInteractorInput
}

extension SettingsPresenter: SettingsPresenterInput {
    func viewDidLoad() {
        
    }
    
    func userDidTapStop() {
        self.interactor.stopOrchextra()
        self.wireframe.dismissSettings()
    }
}
