//
//  UserWireframeRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation
import GIGLibrary

struct UserWireframe {
    
    /// Method to show the UserWireframe section
    ///
    /// - Returns: UserWireframe View Controller with all dependencies
    func showUserWireframe() -> UserVC? {
        guard let viewController = try? UserVC.instantiateFromStoryboard() else {
            LogWarn("UserVC not found")
            return nil
        }
        let wireframe = UserWireframe()
        let presenter = UserPresenter(
            view: viewController,
            wireframe: wireframe
        )
        viewController.presenter = presenter
        return viewController
    }
}
