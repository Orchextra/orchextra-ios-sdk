//
//  ScannerRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct ScannerWireframe {
    
    /// Method to show the Scanner section
    ///
    /// - Returns: Scanner View Controller with all dependencies
    func showScanner() -> ScannerVC? {
        guard let viewController = try? Instantiator<ScannerVC>().viewController() else { return nil }
        let interactor = ScannerInteractor()
        let presenter = ScannerPresenter(
            view: viewController,
            wireframe: self,
            interactor: interactor
        )
        viewController.presenter = presenter
        return viewController
    }
}
