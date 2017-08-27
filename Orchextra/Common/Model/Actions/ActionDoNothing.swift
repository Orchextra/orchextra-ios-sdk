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


    static func action(from json: JSON) -> Action? {
        return ActionDoNothing()
    }
    
    func executable() {
        // DO NOTHING
        LogDebug("Do nothing action")
    }
}
