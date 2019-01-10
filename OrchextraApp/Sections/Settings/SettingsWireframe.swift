//
//  SettingsRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct SettingsWireframe {
    var navigationController: UINavigationController
    
    /// Method to show the Settings section
    ///
    /// - Returns: Settings View Controller with all dependencies
    func showSettings() -> SettingsVC? {
        guard let viewController = try? SettingsVC.instantiateFromStoryboard() else {
            logWarn("SettingsVC not found")
            return nil }
        
        let presenter = SettingsPresenter(
            view: viewController,
            wireframe: self,
            interactor: SettingsInteractor()
        )
        viewController.presenter = presenter
        return viewController
    }
    
    /// Method to show the user view section
    ///
    /// - Returns: User view controller with all dependencies
    func showUserVC() {
        let userWireframe = UserWireframe()
        guard let userVC = userWireframe.showUserWireframe() else {
            logWarn("UserVC not found")
            return
        }
        navigationController.show(userVC, sender: self)
    }
    
    /// Method to show the device view section
    ///
    /// - Returns: Device view controller with all dependencies
    func showDeviceVC() {
        let deviceWireframe = DeviceWireframe()
        guard let deviceVC = deviceWireframe.showDeviceWireframe() else {
            logWarn("deviceVC not found")
            return
        }
        navigationController.show(deviceVC, sender: self)
    }
    
    func dismissSettings() {
        AppController.shared.appWireframe?.showHomeWireframe()
    }

}
