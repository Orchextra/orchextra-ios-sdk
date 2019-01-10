//
//  ActionDoNothing.swift
//  Orchextra
//
//  Created by Judith Medina on 25/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ActionDoNothing: Action {
    
    var id: String?
    var trackId: String?
    var type: String?
    var urlString: String?
    var schedule: ActionSchedule?
    var notification: ActionNotification?

    
    init(id: String,
         trackId: String,
         urlString: String,
         scredule: ActionSchedule?,
         notification: ActionNotification?) {
        self.urlString = urlString
        self.id = id
        self.trackId = trackId
        self.schedule = scredule
        self.urlString = urlString
        self.notification = notification
    }

    static func action(from json: JSON) -> Action? {
        
        guard
            let urlString = json["url"]?.toString(),
            let id = json["id"]?.toString(),
            let trackId = json["trackId"]?.toString() else {
                return nil
        }
        
        return ActionDoNothing(
            id: id,
            trackId: trackId,
            urlString: urlString,
            scredule: schedule(from: json),
            notification: notification(from: json)
        )
    }
    
    func executable() {
        // DO NOTHING
        logDebug("Do nothing action")
    }
}
