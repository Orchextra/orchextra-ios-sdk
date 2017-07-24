//
//  ORCEddystoneUID.swift
//  Orchextra
//
//  Created by Carlos Vicente on 20/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

@objc public class EddystoneUID: NSObject {
    @objc public var namespace:String
    @objc public var instance:String?
    @objc public var uidCompossed: String { get {
        
        let instance = self.instance ?? ""
        return namespace + instance
        }
    }
    
    @objc public init(namespace: String, instance: String?) {
        self.namespace = namespace
        self.instance = instance
    }
}
