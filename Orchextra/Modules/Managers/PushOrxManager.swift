//
//  PushManager.swift
//  Orchextra
//
//  Created by Judith Medina on 31/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UserNotifications
import GIGLibrary

protocol PushOrxInput {
    func configure()
    func dispatchNotification(with action: Action)
    func handleNotification(userInfo: [String: Any])
}

class PushOrxManager: NSObject, PushOrxInput {
    
    /// Singleton
    static var shared = PushOrxManager()
    
    // MARK: - Public attributes
    
    let application = UIApplication.shared
    
    // MARK: - Public
    
    func configure() {
        self.requestForNotifications()
    }
    
    func handleNotification(userInfo: [String: Any]) {
        let jsonNotification = JSON(from: userInfo)

        guard let action = ActionFactory.action(from: jsonNotification) else {
            LogWarn("Action can't be created")
            return
        }
        
        let actionManager = ActionManager()
        actionManager.handler(action: action)
    }

    func dispatchNotification(with action: Action) {
        
        var date: Date?
        if let seconds = action.schedule?.seconds {
            let minutes = seconds/60
            date = Date().addedBy(minutes: minutes)
        }
        let payload = self.payloadLocalNotification(action: action)
        LocalNotification.dispatchlocalNotification(with: action.notification?.title ?? "",
                                                    body: action.notification?.body ?? "",
                                                    userInfo: payload,
                                                    at: date)
    }
    
    // MARK: - Internal
    
    internal func requestForNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, _ in
                    // Granted to use remote notification
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(
                types: [.alert, .badge, .sound],
                categories: nil)
            self.application.registerUserNotificationSettings(settings)
        }
        
        self.application.registerForRemoteNotifications()
    }
    
    // MARK: - Private
    
    private func payloadLocalNotification(action: Action) -> [String: Any] {
        
        var payload: [String: Any] = [:]
        if let trackId = action.trackId { payload["trackId"] = trackId }
        if let type = action.type { payload["type"] = type }
        if let id = action.id { payload["id"] = id }
        if let urlString = action.urlString { payload["url"] = urlString }
        
        let notification = [
            "title": action.notification?.title ?? "",
            "body": action.notification?.body ?? ""]
        payload["notification"] = notification

        return payload
    }
}

@available(iOS 10, *)
extension PushOrxManager: UNUserNotificationCenterDelegate {

}
