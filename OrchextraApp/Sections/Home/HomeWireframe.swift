//
//  HomeRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct HomeWireframe {
    
    var navigationController: UINavigationController
    
    /// Method to show the Home section
    ///
    /// - Returns: Home View Controller with all dependencies
    func showHome() -> HomeVC? {
        guard let viewController = try? Instantiator<HomeVC>().viewController() else { return nil }

        let interactor = HomeInteractor()
        let presenter = HomePresenter(
            view: viewController,
            wireframe: self,
            interactor: interactor
        )
        
        interactor.output = presenter
        viewController.presenter = presenter
        return viewController
    }
}
