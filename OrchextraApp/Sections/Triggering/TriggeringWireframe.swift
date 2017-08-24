//
//  TriggeringRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct TriggeringWireframe {
    
    var navigationController: UINavigationController
    
    /// Method to show the Triggering section
    ///
    /// - Returns: Triggering View Controller with all dependencies
    func showTriggering() -> TriggeringVC? {
        guard let viewController = try? Instantiator<TriggeringVC>().viewController() else { return nil }
        let presenter = TriggeringPresenter(
            view: viewController,
            wireframe: self,
            interactor: TriggeringInteractor()
        )
        viewController.presenter = presenter
        return viewController
    }
}
