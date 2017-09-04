//
//  Region.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol Region {
    
    var identifier: String? {get set}
    var notifyOnEntry: Bool? {get set}
    var notifyOnExit: Bool? {get set}
    
    static func region(from config: [String: Any]) -> Region?
    
}

class RegionFactory {
    
    class func region(from config: [String: Any]) -> Region? {
        let triggers = [
            Geofence.region(from: config)]
        
        return triggers.reduce(nil) { $1 ?? $0 }
        
    }
}
