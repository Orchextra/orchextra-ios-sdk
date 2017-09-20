//
//  ActionBrowserExternal.swift
//  Orchextra
//
//  Created by Carlos Vicente on 30/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ActionBrowserExternal: Action {
    var id: String?
    var trackId: String?
    var type: String?
    var urlString: String?
    var schedule: ActionSchedule?
    var notification: ActionNotification?
    
    init(id: String,
         trackId: String,
         urlString: String,
         type: String,
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
        guard let type = json["type"]?.toString(),
            type == ActionType.actionBrowserExternal,
            let urlString = json["url"]?.toString(),
            let id = json["id"]?.toString(),
            let trackId = json["trackId"]?.toString() else {
                return nil
        }
        
        return ActionBrowserExternal(
            id: id,
            trackId: trackId,
            urlString: urlString,
            type: type,
            scredule: schedule(from: json),
            notification: notification(from: json)
        )
    }
    
    func executable() {
        guard let urlString = self.urlString,
            let url = URL(string: urlString) else {
                LogWarn("Url malformatted, we can't create action webview.")
                return
        }
        DispatchQueue.global().sync {
            OrchextraWrapper.shared.wireframe.openBrowserExternal(url: url)
        }
    }
}
