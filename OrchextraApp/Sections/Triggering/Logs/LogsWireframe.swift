//
//  LogsRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct LogsWireframe {
    
    /// Method to show the Logs section
    ///
    /// - Returns: Logs View Controller with all dependencies
    func showLogs() -> LogsVC? {
        guard let viewController = try? Instantiator<LogsVC>().viewController() else { return nil }
        let presenter = LogsPresenter(
            view: viewController,
            wireframe: self,
            interactor: LogsInteractor()
        )
        viewController.presenter = presenter
        return viewController
    }
}
