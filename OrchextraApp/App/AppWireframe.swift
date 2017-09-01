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
        self.window?.rootViewController = self.navigationController
    }
    
    /// Method to show the Triggering wireframe
    func showTriggering()  {
        let triggeringWireframe = TriggeringWireframe()
        guard let triggeringVC = triggeringWireframe.showTriggering() else {
            LogWarn("TriggeringVC not found")
            return
        }
        
//        let navController = UINavigationController(rootViewController: triggeringVC)
        self.navigationController.show(triggeringVC, sender: nil)
        triggeringWireframe.navigationController = self.navigationController
    }
    
    func show(viewController: UIViewController) {
        self.navigationController.show(viewController, sender: nil)
    }
}
