//
//  ActionScanner.swift
//  Orchextra
//
//  Created by Judith Medina on 28/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ActionScanner: Action {
    
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
        
        guard let type = json["type"]?.toString(), type == ActionType.actionScanner,
            let urlString = json["url"]?.toString(),
            let id = json["id"]?.toString(),
            let trackId = json["trackId"]?.toString() else {
                return nil
        }
        
        return ActionScanner(
            id: id,
            trackId: trackId,
            urlString: urlString,
            type: type,
            scredule: schedule(from: json),
            notification: notification(from: json)
        )
    }
    
    func executable() {        
        var scanner = OrchextraWrapper.shared.scanner
        let wireframe = OrchextraWrapper.shared.wireframe
        let moduleOutputWrapper = OrchextraWrapper.shared.moduleOutputWrapper

        if scanner == nil {
            scanner = wireframe.scannerOrx()
            OrchextraWrapper.shared.scanner = scanner
        }
        guard let scannerVC = scanner as? UIViewController else {
            return
        }
        scanner?.outputModule = moduleOutputWrapper
        wireframe.openScanner(scanner: scannerVC)
        scanner?.start()
    }
}
