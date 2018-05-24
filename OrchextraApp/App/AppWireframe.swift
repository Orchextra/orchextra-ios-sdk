//
//  AppWireframe.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class AppWireframe {
    // MARK: - Attributes
    var window: UIWindow?
 
    /// Method to show the Home wireframe
    
    func showHomeWireframe() {
        let homeWireframe = HomeWireframe()
        guard let homeVC = homeWireframe.showHome() else {
            LogWarn("HomeVC not found")
            return
        }
        
        self.window?.rootViewController = homeVC
    }
    
    /// Method to show the Triggering wireframe
    func showTriggering() {
        let triggeringWireframe = TriggeringWireframe()
        guard let triggeringVC = triggeringWireframe.showTriggering() else {
            LogWarn("TriggeringVC not found")
            return
        }
        let navigationController = UINavigationController(rootViewController: triggeringVC)
        triggeringWireframe.navigationController = navigationController
        self.window?.rootViewController = navigationController
    }

}
