//
//  ORCEddystoneUID.swift
//  Orchextra
//
//  Created by Carlos Vicente on 20/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

@objc public class ORCEddystoneUID: NSObject {
    // MARK: Public properties
    @objc public var namespace:String
    @objc public var instance:String?
    
    // MARK: Public computed properties
    @objc public var uidCompossed: String {
        get {
            let instance = self.instance ?? ""
            return namespace + instance
        }
    }
    
    // MARK: Public methods
    @objc public init(namespace: String, instance: String?) {
        self.namespace = namespace
        self.instance = instance
    }
    
    // MARK: Equatable protocol methods
    public override func isEqual(_ object: Any?) -> Bool {
        guard let objectToCompare = object as? ORCEddystoneUID else { return false }
        if self.namespace == objectToCompare.namespace,
            self.instance == objectToCompare.instance,
            self.uidCompossed == objectToCompare.uidCompossed {
            return true
        }
        return false
    }
}
