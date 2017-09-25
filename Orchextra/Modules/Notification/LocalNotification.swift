//
//  LocalNotification.swift
//  Orchextra
//
//  Created by Judith Medina on 31/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UserNotifications
import GIGLibrary

class LocalNotification: NSObject {
    
    class func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil, at date: Date?) {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "com.orchextra.localnotification"
            
            if let info = userInfo {
                content.userInfo = info
            }
            
            content.sound = UNNotificationSound.default()
            
            var trigger: UNNotificationTrigger?
            if let deliveryDate = date {
                let comp = Calendar.current.dateComponents([.hour, .minute], from: deliveryDate)
                trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            }
            if let id = userInfo?["id"] as? String {
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                center.add(request)
            }
            
        } else {
            
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertTitle = title
            notification.alertBody = body
            
            if let info = userInfo {
                notification.userInfo = info
            }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        LogDebug("Will dispatch notification at \(String(describing: date))")
    }
    
    func removeLocalNotification(id: String) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [id])
        } else {
   
        }
    }
}
