//
//  Geofence.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation
import GIGLibrary

struct Geofence: Region {
    
    // Attribute Region
    
    var identifier: String?
    var notifyOnEntry: Bool?
    var notifyOnExit: Bool?
    
    // Attribute Geofences
    
    var code: String
    var center: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var staytime: Double

    static func region(from config: [String: Any]) -> Region? {
        
        guard let type = config["type"] as? String, type == "geofence",
            let id = config["id"] as? String,
            let code = config["code"] as? String,
            let notifyOnEntry = config["notifyOnEntry"] as? Bool,
            let notifyOnExit = config["notifyOnExit"] as? Bool,
            let radiusDouble = config["radius"] as? Double,
            let stayTime = config["staytime"] as? Double,
            let pointDic = config["point"] as? [String : Any],
            let point = Point(from: pointDic)
        else { return nil }

        let center = CLLocationCoordinate2D(
            latitude: point.latitud,
            longitude: point.longitud)
        
        return Geofence(identifier: id,
                        notifyOnEntry: notifyOnEntry,
                        notifyOnExit: notifyOnExit,
                        code: code,
                        center: center,
                        radius: radiusDouble,
                        staytime: stayTime)
    }
}


struct Point {
    
    var longitud: Double
    var latitud: Double
    
    init?(from json: [String: Any]) {
        
        guard let lng = json["lng"] as? Double,
            let lat = json["lat"] as? Double else {
                LogWarn("Point not well formatted")
                return nil
        }
        
        self.longitud = lng
        self.latitud = lat
    }
    
}
