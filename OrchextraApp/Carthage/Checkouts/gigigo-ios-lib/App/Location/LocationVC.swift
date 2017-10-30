//
//  LocationVC.swift
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/9/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//


class LocationVC: UIViewController {
    
    @IBOutlet var labelLocation: UILabel!
    
    var geolocation: GIGGeolocation?
    
    override func viewDidLoad() {
        
        self.labelLocation.numberOfLines = 0
        
        self.geolocationUser()
        
        print("¿Autorizado?: \(geolocation!.isAuthorized())")
    }
    
    
    func geolocationUser() {
        self.geolocation = GIGGeolocation()
        
        geolocation!.locate {status, authorized, location, error in
            self.labelLocation.text = "Esperando ..."
            
            if (authorized && status) {
                self.labelLocation.text = "Localizacion correcta, latitud: \(String(describing: location?.coordinate.latitude))   y longitud: \(String(describing: location?.coordinate.longitude))"
            }
            else {
                self.labelLocation.text = error?.localizedDescription
            }
        }
    }
}
