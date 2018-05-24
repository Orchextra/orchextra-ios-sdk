//
//  TriggeringRouter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggeringWireframe {
    // MARK: - Attributes
    var navigationController: UINavigationController?
    
    /// Method to show the Triggering section
    ///
    /// - Returns: Triggering View Controller with all dependencies
    func showTriggering() -> TriggeringVC? {
        guard let viewController = try? TriggeringVC.instantiateFromStoryboard() else {
            LogWarn("TriggeringVC not found")
            return nil }
        let presenter = TriggeringPresenter(
            view: viewController,
            wireframe: self,
            interactor: TriggeringInteractor()
        )
        
        viewController.presenter = presenter
        
        return viewController
    }
    
    /// Method to show the Scanner section
    ///
    /// - Returns: Scanner View Controller with all dependencies
    func showScanner() -> ScannerVC? {
        guard let navigationController = self.navigationController else { return nil }
        let scannerWireframe = ScannerWireframe(navigationController: navigationController)
        guard let scannerVC = scannerWireframe.showScanner() else { return nil }
        
        return scannerVC
    }
    
    /// Method to show the Gefences section
    ///
    /// - Returns: Scanner View Controller with all dependencies
    func showGeofences() -> GeofencesVC? {
        let geofencesWireframe = GeofencesWireframe()
        guard let geofencesVC = geofencesWireframe.showGeofences() else { return nil }
        
        return geofencesVC
    }
    
    /// Method to show the Logs section
    ///
    /// - Returns: Scanner View Controller with all dependencies
    func showLogs() -> LogsVC? {
        guard let navigationController = self.navigationController else { return nil }
        let logsWireframe = LogsWireframe(navigationController: navigationController)
        guard let logsVC = logsWireframe.showLogs() else {
            return nil
        }
        
        return logsVC
    }
    
    /// Method to show the Settings section
    ///
    /// - Returns: Settings View Controller with all dependencies
    func showSettings() {
        guard let navigationController = self.navigationController else {
            LogWarn("NavigationController nil")
            return
        }
        let settingsWireframe = SettingsWireframe(navigationController: navigationController)
        guard let settingsVC = settingsWireframe.showSettings() else {
            LogWarn("SettingsVC not found")
            return
        }
        navigationController.show(settingsVC, sender: self)
    }
    
    /// Method to show the Triggering sections
    ///
    /// - Returns: Settings View Controller with all dependencies
    func showTriggeringViewControllers() -> [UIViewController] {
        guard let scannerVC = self.showScanner(),
            let geofencesVC = self.showGeofences(),
            let logsVC = self.showLogs() else { return [UIViewController]() }
        
            return [scannerVC, geofencesVC, logsVC]
        }
}
