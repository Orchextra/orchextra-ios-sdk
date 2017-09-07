//
//  CustomScannerRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 6/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import Orchextra

struct CustomScannerWireframe {
    let navigationController: UINavigationController
    
    /// Method to show the CustomScanner section
    ///
    /// - Returns: CustomScanner View Controller with all dependencies
    func showCustomScanner() -> CustomScannerVC? {
        guard let viewController = try? Instantiator<CustomScannerVC>().viewController() else { return nil }
        let presenter = CustomScannerPresenter(
            view: viewController,
            wireframe: self,
            inputModule: viewController
        )
        viewController.presenter = presenter
        
        return viewController
    }
    
    func dismissCustomScanner(completion: (() -> Void)?) {
        self.navigationController.dismiss(animated: true, completion: completion)
    }
}
