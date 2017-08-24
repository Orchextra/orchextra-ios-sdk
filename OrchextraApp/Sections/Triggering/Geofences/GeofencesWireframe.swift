//
//  GeofencesRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct GeofencesWireframe {
    
    /// Method to show the Geofences section
    ///
    /// - Returns: Geofences View Controller with all dependencies
    func showGeofences() -> GeofencesVC? {
        guard let viewController = try? Instantiator<GeofencesVC>().viewController() else { return nil }
        let wireframe = GeofencesWireframe()
        let presenter = GeofencesPresenter(
            view: viewController,
            wireframe: wireframe
        )
        viewController.presenter = presenter
        return viewController
    }
}
