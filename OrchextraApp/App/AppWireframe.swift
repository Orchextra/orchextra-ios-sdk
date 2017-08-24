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
    var window: UIWindow?
    private var navigationController = UINavigationController()
 
    /// Method to show the Home wireframe
    func showHomeWireframe()  {
        let homeWireframe = HomeWireframe(navigationController: self.navigationController)
        guard let homeVC = homeWireframe.showHome() else {
            LogWarn("HomeVC not found")
            return
        }
        
        self.navigationController.setViewControllers([homeVC], animated: false)
        
        window?.rootViewController = self.navigationController
    }
    
    /// Method to show the Settings wireframe
    func showSettings()  {
        let settingsWireframe = SettingsWireframe(navigationController: self.navigationController)
        guard let settingsVC = settingsWireframe.showSettings() else {
            LogWarn("SettingsVC not found")
            return
        }
        
        self.navigationController.show(settingsVC, sender: nil)
    }
    
    /// Method to show the Triggering wireframe
    func showTriggering()  {
        let triggeringWireframe = TriggeringWireframe(navigationController: self.navigationController)
        guard let triggeringVC = triggeringWireframe.showTriggering() else {
            LogWarn("TriggeringVC not found")
            return
        }
        
        self.navigationController.show(triggeringVC, sender: nil)
    }
}
