//
//  AppDelegate.swift
//  OrchextraApp
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appController = AppController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        prepareAppController()
        appController.appDidLaunch()
        self.setNavBarAppearance()
        
        return true
    }

    // MARK: - Private Helpers
    
    fileprivate func prepareAppController() {
        appController.appWireframe = AppWireframe()
        appController.appWireframe?.window = self.window
    }
    
    func setNavBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.ORXApp.coral
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}


