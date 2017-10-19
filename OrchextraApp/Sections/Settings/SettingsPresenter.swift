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
    func userDidTapLogOut()
    func userDidTapEdit()
    func userDidTapUserView()
    func userDidTapDeviceView()
}

protocol SettingsUI: class {
    func initializeSubviews(with projectName: String, apiKey: String, apiSecret: String, editable: Bool)
    func updateEditableState(title: String)
    func updateNotEditableState(title: String)
}

class SettingsPresenter {
        
    // MARK: - Public attributes
    
    weak var view: SettingsUI?
    let wireframe: SettingsWireframe
    var isEditable: Bool
    
    // MARK: - Interactors
    
    let interactor: SettingsInteractorInput
    
    init(view: SettingsUI, wireframe: SettingsWireframe, interactor: SettingsInteractorInput) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
        self.isEditable = false
    }
}

extension SettingsPresenter: SettingsPresenterInput {
    func viewDidLoad() {
        var projectName = ""
        let apiKey = self.interactor.loadApiKey() ?? Constants.apiKey
        let apiSecret = self.interactor.loadApiSecret() ?? Constants.apiSecret
        
        if apiKey == Constants.apiKey,
            apiSecret == Constants.apiSecret {
             projectName = Constants.projectName
        }
        self.view?.initializeSubviews(
            with: projectName,
            apiKey: apiKey,
            apiSecret: apiSecret,
            editable: self.isEditable)
    }
    
    func userDidTapLogOut() {
        self.interactor.stopOrchextra()
        self.wireframe.dismissSettings()
    }
    
    func userDidTapEdit() {
        let currentState = self.isEditable
        self.isEditable = !currentState
        if self.isEditable {
            self.view?.updateEditableState(title: "Save")
        } else {
            self.view?.updateNotEditableState(title: "Edit")
        }
    }
    
    func userDidTapUserView() {
        self.wireframe.showUserVC()
    }
    
    func userDidTapDeviceView() {
        self.wireframe.showDeviceVC()
    }
}
