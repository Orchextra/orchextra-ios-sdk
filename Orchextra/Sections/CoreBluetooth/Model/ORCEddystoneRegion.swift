//
//  ORCEddystoneRegion.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/5/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

@objc public enum regionEvent: Int {
    case undetected
    case enter
    case stay
    case exit
}

@objc public class ORCEddystoneRegion: NSObject {
    // MARK: Public properties
     public let uid:EddystoneUID
     public var regionEvent: regionEvent
    
    // MARK: Private properties
     let notifyOnEntry: Bool
     let notifyOnExit: Bool
    
      public init?(json: [AnyHashable: Any]) {
        guard let namespace: String = (json["namespace"] as? String) else {
            return nil
        }
        let instance: String? = json["instance"] as? String
        let uid = EddystoneUID(namespace: namespace, instance: instance)
        self.uid = uid
        self.regionEvent = .undetected
        self.notifyOnEntry = (json["notifyOnEntry"] as? Bool) ?? false
        self.notifyOnExit = (json["notifyOnExit"] as? Bool) ?? false
    }
    
     init(uid: EddystoneUID, notifyOnEntry: Bool, notifyOnExit: Bool) {
        self.uid = uid
        self.regionEvent = .undetected
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
    }
}
