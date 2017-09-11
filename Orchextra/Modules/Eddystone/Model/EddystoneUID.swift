//
//  EddystoneUID.swift
//  Orchextra
//
//  Created by Carlos Vicente on 20/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

class EddystoneUID: NSObject {
    // MARK: Public properties
    var namespace:String
    var instance:String?
    
    // MARK: Public computed properties
    var uidCompossed: String {
        get {
            let instance = self.instance ?? ""
            return namespace + instance
        }
    }
    
    // MARK: Public methods
    init(namespace: String, instance: String?) {
        self.namespace = namespace
        self.instance = instance
    }
    
    // MARK: Equatable protocol methods
    override func isEqual(_ object: Any?) -> Bool {
        guard let objectToCompare = object as? EddystoneUID else { return false }
        if self.namespace == objectToCompare.namespace,
            self.instance == objectToCompare.instance,
            self.uidCompossed == objectToCompare.uidCompossed {
            return true
        }
        return false
    }
}
