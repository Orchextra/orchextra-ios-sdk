//
//  FilterRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct FilterWireframe {
    
    /// Method to show the Filter section
    ///
    /// - Returns: Filter View Controller with all dependencies
    func showFilter() -> FilterVC? {
        guard let viewController = try? Instantiator<FilterVC>().viewController() else { return nil }
        let wireframe = FilterWireframe()
        let presenter = FilterPresenter(
            view: viewController,
            wireframe: wireframe,
            interactor: FilterInteractor()
        )
        viewController.presenter = presenter
        return viewController
    }
}
