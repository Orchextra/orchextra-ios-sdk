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
        guard let scannerVC = self.showScanner(),
        let geofencesVC = self.showGeofences(),
        let logsVC = self.showLogs() else { return viewController }
        viewController.viewControllers = [scannerVC, geofencesVC, logsVC]
        
        return viewController
    }
    
    func showScanner() -> ScannerVC? {
        let scannerWireframe = ScannerWireframe()
        guard let scannerVC = scannerWireframe.showScanner() else { return nil }
        
        return scannerVC
    }
    
    func showGeofences() -> GeofencesVC? {
        let geofencesWireframe = GeofencesWireframe()
        guard let geofencesVC = geofencesWireframe.showGeofences() else { return nil }
        
        return geofencesVC
    }
    
    func showLogs() -> LogsVC? {
        let logsWireframe = LogsWireframe()
        guard let logsVC = logsWireframe.showLogs() else { return nil }
        
        return logsVC
    }
}
