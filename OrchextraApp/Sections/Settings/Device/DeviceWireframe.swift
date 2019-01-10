//
//  DeviceWireframeRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation
import GIGLibrary

struct DeviceWireframe {
    
    /// Method to show the DeviceWireframe section
    ///
    /// - Returns: DeviceWireframe View Controller with all dependencies
    func showDeviceWireframe() -> DeviceVC? {
        guard let viewController = try? DeviceVC.instantiateFromStoryboard() else {
            logWarn("DeviceVC not found")
            return nil
        }
        let interactor = DeviceInteractor()
        let wireframe = DeviceWireframe()
        let presenter = DevicePresenter(
            view: viewController,
            wireframe: wireframe,
            interactor: interactor
        )
        viewController.presenter = presenter
        return viewController
    }
}
