//
//  FilterRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class FilterWireframe {
    // MARK: - Attributes
    var navigationController: UINavigationController
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Method to show the Filter section
    ///
    /// - Parameter interactor: The filter interactor needed to filter logs.
    /// - Returns: Filter View Controller with all dependencies
    func showFilter(with interactor: FilterInteractor) -> FilterVC? {
        guard let viewController = try? FilterVC.instantiateFromStoryboard() else {
            logWarn("FilterVC not found")
            return nil }
        
        let presenter = FilterPresenter(
            view: viewController,
            wireframe: self,
            interactor: interactor
        )
        
        interactor.output = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
    func dismissFilterVC() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
}
