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
    
    var code: String
    var notifyOnEntry: Bool?
    var notifyOnExit: Bool?
    
    // Attribute Geofences
    
    var center: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var staytime: Double

    static func region(from config: [String: Any]) -> Region? {
        
        guard let code = config["code"] as? String,
            let notifyOnEntry = config["notifyOnEntry"] as? Bool,
            let notifyOnExit = config["notifyOnExit"] as? Bool,
            let radiusDouble = config["radius"] as? Double,
            let stayTime = config["stayTime"] as? Double,
            let pointDic = config["point"] as? [String : Any],
            let point = Point(from: pointDic)
        else { return nil }

        let center = CLLocationCoordinate2D(
            latitude: point.latitud,
            longitude: point.longitud)
        
        return Geofence(code: code,
                        notifyOnEntry: notifyOnEntry,
                        notifyOnExit: notifyOnExit,
                        center: center,
                        radius: radiusDouble,
                        staytime: stayTime)
    }
    
    func prepareCLRegion() -> CLRegion? {
        
        let region = CLCircularRegion(center: self.center, radius: self.radius, identifier: self.code)
        
        if let notifyOnExit = self.notifyOnExit { region.notifyOnExit = notifyOnExit }
        if let notifyOnEntry = self.notifyOnEntry { region.notifyOnEntry = notifyOnEntry }
        
        return region
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
