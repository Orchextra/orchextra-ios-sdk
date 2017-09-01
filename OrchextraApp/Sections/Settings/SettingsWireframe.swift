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
        guard let viewController = try? Instantiator<SettingsVC>().viewController() else { return nil }
        
        let presenter = SettingsPresenter(
            view: viewController,
            wireframe: self,
            interactor: SettingsInteractor()
        )
        viewController.presenter = presenter
        return viewController
    }
    
    func dismissSettings() {
//        guard let topViewController = self.navigationController.topViewController,
//            topViewController.isKind(of: SettingsVC.self) else { return }
        
        self.navigationController.popToRootViewController(animated: true)
    }

}
