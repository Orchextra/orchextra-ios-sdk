//
//  Action.swift
//  Orchextra
//
//  Created by Judith Medina on 25/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary


struct ActionType {
    static let actionWebview = "webview"
    static let actionBrowser = "browser"
    static let actionBrowserExternal = "browser_external"
    static let actionScanner = "scan"
    static let actionIR = "scan_vuforia"
    static let actionCustomScheme = "custom_scheme"
    static let actionLocalNotification = "notification"
}

protocol Action {
    
    var id: String? {get set}
    var trackId: String? {get set}
    var type: String? {get set}
    var urlString: String? {get set}
    var schedule: ActionSchedule? {get set}
    var notification: ActionNotification? {get set}

    static func action(from json: JSON) -> Action?
    func run(viewController: UIViewController?)
    func executable()
}

// DEFAULT IMPLEMENTATION

extension Action {
    
    static func schedule(from json: JSON) -> ActionSchedule? {
        guard let schedule = json["schedule"]?.toDictionary(),
            let seconds = schedule["seconds"] as? Int,
            let cancelable = schedule["cancelable"] as? Bool else {
                LogDebug("Action doesn't have delay")
                return nil
        }
        return ActionSchedule(seconds: seconds, cancelable: cancelable)
    }
    
    static func notification(from json: JSON) -> ActionNotification? {
        guard let notification = json["notification"]?.toDictionary(),
            let title = notification["title"] as? String,
            let body = notification["body"] as? String else {
                LogDebug("Action doesn't have notification")
                return nil
        }
        return ActionNotification(title: title, body: body)
    }
    
    func run(viewController: UIViewController?) { }
}

class ActionFactory {
    
    class func action(from json: JSON) -> Action? {
        let actions = [
            ActionBrowser.action(from: json),
            ActionWebView.action(from: json),
            ActionScanner.action(from: json),
            ActionBrowserExternal.action(from: json)
        ]
        
        // Returns the last action that is not nil, or custom scheme is there is no actions
        return actions.reduce(ActionDoNothing.action(from: json)) { $1 ?? $0 }
    }
}


// MARK: - Action Notification

struct ActionNotification {
    var title: String
    var body: String
}

// MARK: - Action Schedule

struct ActionSchedule {
    var seconds: Int
    var cancelable: Bool
}
