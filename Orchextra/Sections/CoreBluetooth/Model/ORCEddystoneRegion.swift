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

@objc public class ORCEddystoneRegion: NSObject, NSCoding {
    // MARK: Public properties
     public let uid:ORCEddystoneUID
     @objc public var regionEvent: regionEvent
     @objc public let code: String
    
    // MARK: Private properties
     let notifyOnEntry: Bool
     let notifyOnExit: Bool
    
      @objc public init?(json: [AnyHashable: Any]) {
        guard let namespace = (json["namespace"] as? String),
            let code = json["code"] as? String else {
            return nil
        }
        let instance: String? = json["instance"] as? String
        let uid = ORCEddystoneUID(namespace: namespace, instance: instance)
        self.uid = uid
        self.regionEvent = .undetected
        self.code = code
        self.notifyOnEntry = (json["notifyOnEntry"] as? Bool) ?? false
        self.notifyOnExit = (json["notifyOnExit"] as? Bool) ?? false
    }
    
    @objc public init(uid: ORCEddystoneUID, code: String, notifyOnEntry: Bool, notifyOnExit: Bool) {
        self.uid = uid
        self.code = code
        self.regionEvent = .undetected
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
    }
    
    // MARK: NSCoding delegate methods
    public required init?(coder aDecoder: NSCoder) {
        let namespace: String =  (aDecoder.decodeObject(forKey: "namespace") as? String) ?? ""
        let instance: String? = (aDecoder.decodeObject(forKey: "instance") as? String) ?? ""
        let uid = ORCEddystoneUID(namespace: namespace, instance: instance)
        self.uid = uid
        self.code = (aDecoder.decodeObject(forKey: "code") as? String) ?? ""
        self.regionEvent = .undetected
        self.notifyOnEntry = (aDecoder.decodeBool(forKey: "notifyOnEntry"))
        self.notifyOnExit = (aDecoder.decodeBool(forKey: "notifyOnExit"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uid.namespace, forKey: "namespace")
        aCoder.encode(self.uid.instance, forKey: "instance")
        aCoder.encode(self.code, forKey: "code")
        aCoder.encode(self.notifyOnEntry, forKey: "notifyOnEntry")
        aCoder.encode(self.notifyOnEntry, forKey: "notifyOnExit")
    }
}
