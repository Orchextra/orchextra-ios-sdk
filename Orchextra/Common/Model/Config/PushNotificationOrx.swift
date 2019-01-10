//
//  PushNotificationOrx.swift
//  Orchextra
//
//  Created by Carlos Vicente on 10/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

public struct PushNototificationORX {
    let title: String?
    let subtitle: String?
    let body: String?
    let badge: Int
    
    static func parse(from json: JSON) -> PushNototificationORX? {
        guard let dataDict = json["data"]?.toDictionary() else {
             logWarn("data node is nil")
            return nil
        }
        
        let data: JSON = JSON(from: dataDict)
        
        guard let jsonOrchextraNotification = data["isOrchextra"]?.toBool(),
            jsonOrchextraNotification == true else {
                logWarn("Push notification not handled by Orchextra")
                return nil
        }
       
        guard let apsDictionary = json["aps"]?.toDictionary() else {
            logWarn("aps node is nil")
            return nil
        }
        
        let apsJson: JSON = JSON(from: apsDictionary)
        
        guard let alert = apsJson["alert"]?.toDictionary() else {
            logWarn("alert node is nil")
            return nil
        }
        
        let alertJson: JSON = JSON(from: alert)
        
        guard let badge = apsJson["badge"]?.toInt() else {
            return nil
        }
        
        let title = alertJson["title"]?.toString()
        let subtitle = alertJson["subtitle"]?.toString()
        let body = alertJson["body"]?.toString()
        return PushNototificationORX(
            title: title,
            subtitle: subtitle,
            body: body,
            badge: badge
        )
    }
}
