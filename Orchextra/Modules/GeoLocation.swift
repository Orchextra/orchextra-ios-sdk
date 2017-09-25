//
//  GeoLocation.swift
//  Orchextra
//
//  Created by Judith Medina on 08/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoLocation {
    
    var lat: Double
    var lng: Double
    
    var country: String?
    var countryCode: String?
    var locality: String?
    var zip: String?
    var street: String?
    
    init(location: CLLocation, placemark: CLPlacemark?) {
        self.lat = Double(location.coordinate.latitude)
        self.lng = Double(location.coordinate.longitude)
        self.country = placemark?.country
        self.countryCode = placemark?.isoCountryCode
        self.locality = placemark?.locality
        self.zip = placemark?.postalCode
        self.street = placemark?.thoroughfare
    }
    
    func paramsGeoLocation() -> [String: Any] {
        let point = ["lat": self.lat,
                     "lng": self.lng]
        
        var params: [String: Any] = [String: Any]()
        if let country = self.country { params["country"] = country }
        if let countryCode = self.countryCode { params["countryCode"] = countryCode }
        if let locality = self.locality { params["locality"] = locality }
        if let zip = self.zip { params["zip"] = zip }
        if let street = self.street { params["street"] = street }
        params["point"] = point

        return ["geoLocation": params]
    }
}
