//
//  AppDelegate.swift
//  OrchextraApp
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import UserNotifications
import Orchextra
import GIGLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appController = AppController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        prepareAppController()
        appController.appDidLaunch()
        self.setNavBarAppearance()
        self.setTabBarAppearance()
        
        return true
    }
    
    // MARK: - Handler notification

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {
            LogWarn("Notification does not have userinfo")
            return }
        Orchextra.shared.handleNotification(userInfo: userInfo)
    }

    // MARK: - Private Helpers
    
    fileprivate func prepareAppController() {
        appController.appWireframe = AppWireframe()
        appController.appWireframe?.window = self.window
    }
    
    func setTabBarAppearance() {
        let selectedColor = UIColor.ORXApp.coral
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor as Any], for: .selected)
    }
    
    func setNavBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.ORXApp.coral
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate  {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}

