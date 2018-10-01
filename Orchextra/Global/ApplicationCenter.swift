//
//  ApplicationCenter.swift
//  Orchextra
//
//  Created by Judith Medina on 06/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UserNotifications
import GIGLibrary

class ApplicationCenter {
    
    let notificationCenter: NotificationCenter
    
    convenience init() {
        let notificationCenter = NotificationCenter.default
        self.init(notificationCenter: notificationCenter)
    }

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func observeAppDelegateEvents() {
        
        self.notificationCenter.addObserver(self, selector: #selector(self.applicationdidFinishLaunchingWithOptions),
                                            name: UIApplication.didFinishLaunchingNotification, object: UIApplication.shared)
        
        
        self.notificationCenter.addObserver(self, selector: #selector(self.applicationDidEnterBackground),
                                            name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
    }
    
    func removeAppDelegateEvents() {
        self.notificationCenter.removeObserver(self, name: UIApplication.didFinishLaunchingNotification, object: nil)
        self.notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    

    @objc func applicationdidFinishLaunchingWithOptions() {
        
    }
    
    @objc func applicationDidEnterBackground() {

    }
    
}
