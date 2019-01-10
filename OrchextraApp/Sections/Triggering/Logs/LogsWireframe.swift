//
//  LogsRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class LogsWireframe {
    // MARK: - Attributes
    var navigationController: UINavigationController
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Method to show the Logs section
    ///
    /// - Returns: Logs View Controller with all dependencies
    func showLogs() -> LogsVC? {
        guard let viewController = try? LogsVC.instantiateFromStoryboard() else {
            logWarn("LogsVC not found")
            return nil }
        let filterInteractor = FilterInteractor()
        let interactor = LogsInteractor(filterInteractor: filterInteractor)
        let presenter = LogsPresenter(
            view: viewController,
            wireframe: self,
            interactor: interactor
        )
        interactor.output = presenter
        viewController.presenter = presenter
        return viewController
    }
    
    func showFilterVC(with interactor: FilterInteractor) {
        guard let filtersVC = FilterWireframe(navigationController: self.navigationController).showFilter(with: interactor) else { return }
        let navigationController = UINavigationController(rootViewController: filtersVC)
        self.navigationController.present(navigationController, animated: true, completion: nil)
    
    }
}
