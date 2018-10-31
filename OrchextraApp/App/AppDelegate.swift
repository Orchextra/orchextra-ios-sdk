//
//  AppDelegate.swift
//  OrchextraApp
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import UserNotifications
import GIGLibrary
import Applivery

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	let appController = AppController.shared
    var locationManager: CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.makeKeyAndVisible()
		
		prepareAppController()
		appController.appDidLaunch()
		self.setNavBarAppearance()
		self.setTabBarAppearance()
		
        self.setupApplivery()
        UIApplication.shared.setMinimumBackgroundFetchInterval(1.0)
		
		return true
	}
	
	// MARK: - Handler local notification
	
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		guard let userInfo = notification.userInfo else {
			LogWarn("Notification does not have userinfo")
			return }
		OrchextraWrapperApp.shared.handleLocalNotification(userInfo: userInfo)
	}
    
    // MARK: - Handler remote notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        OrchextraWrapperApp.shared.handleRemoteNotification(userInfo: userInfo)
    }
	
	// MARK: - Private Helpers
	
    fileprivate func prepareAppController() {
        appController.appWireframe = AppWireframe()
        appController.appWireframe?.window = self.window
	}
	
	func setTabBarAppearance() {
		let selectedColor = UIColor.ORXApp.coral
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedColor as Any], for: .selected)
	}
	
	func setNavBarAppearance() {
		let navigationBarAppearace = UINavigationBar.appearance()
		navigationBarAppearace.isTranslucent = false
		navigationBarAppearace.tintColor = UIColor.white
		navigationBarAppearace.barTintColor = UIColor.ORXApp.coral
        navigationBarAppearace.titleTextAttributes = [.foregroundColor: UIColor.white]
	}
	
	private func setupApplivery() {
		#if !DEBUG
			let apiKey = InfoDictionary("APPLIVERY_API_KEY")
			let appID = InfoDictionary("APPLIVERY_APP_ID")
			
			let applivery = Applivery.shared
			applivery.logLevel = .debug
			applivery.start(apiKey: apiKey, appId: appID, appStoreRelease: false)
		#endif
	}
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        OrchextraWrapperApp.shared.openEddystone(with: completionHandler)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        OrchextraWrapperApp.shared.remote(apnsToken: deviceToken)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
	}
	
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
	}
}
