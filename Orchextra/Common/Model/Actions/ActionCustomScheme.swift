//
//  ActionCustomScheme.swift
//  Orchextra
//
//  Created by Carlos Vicente on 8/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ActionCustomScheme: Action {
    var id: String?
    var trackId: String?
    var type: String?
    var urlString: String?
    var schedule: ActionSchedule?
    var notification: ActionNotification?
    
    convenience init() {
        self.init(id: nil, trackId: nil, urlString: nil, type: nil, scredule: nil, notification: nil)
    }
    
    init(id: String?,
         trackId: String?,
         urlString: String?,
         type: String?,
         scredule: ActionSchedule?,
         notification: ActionNotification?) {
        self.urlString = urlString
        self.id = id
        self.trackId = trackId
        self.schedule = scredule
        self.urlString = urlString
        self.type = type
        self.notification = notification
    }
    
    static func action(from json: JSON) -> Action? {
        
        guard let type = json["type"]?.toString(), type == ActionType.actionCustomScheme,
            let urlString = json["url"]?.toString(),
            let id = json["id"]?.toString(),
            let trackId = json["trackId"]?.toString() else {
                return nil
        }
        
        return ActionCustomScheme(
            id: id,
            trackId: trackId,
            urlString: urlString,
            type: type,
            scredule: schedule(from: json),
            notification: notification(from: json)
        )
    }
    
    func executable() {
        guard let url = self.urlString else {
            logWarn("Custom scheme invalid url set")
            return
        }
        
        guard let orxCustomScheme = CustomSchemeFactory.customScheme(from: url) else {
            logInfo("Custom scheme not managed by Orchextra")
            // Inform the integrative app about the trigger
            Orchextra.shared.delegate?.customScheme(url)
            return
        }
        orxCustomScheme.execute()
    }
}
