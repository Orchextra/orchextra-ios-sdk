//
//  GeofencesVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import MapKit
import GIGLibrary

class GeofencesVC: UIViewController, GeofencesUI {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Attributtes
    
    var presenter: GeofencesPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeMapView()
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - Private
    // MARK: - Utility
    
    private func initializeMapView() {
        self.mapView.delegate = self
        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    private func drawCircleOverlay(with region: CLCircularRegion) {
        let circle = MKCircle(
            center: region.center,
            radius: region.radius
        )
        self.mapView.addOverlay(circle)
    }

    private func drawOnMap(geofences: [CLCircularRegion]) {
        for geofence in geofences {
            let annotation = RegionAnnotation(
                title: geofence.identifier,
                coordinate: geofence.center
            )
            self.mapView.addAnnotation(annotation)
            self.drawCircleOverlay(with: geofence)
        }
    }
}

extension GeofencesVC: Instantiable {
    
    // MARK: - Instantiable
    
    static var storyboard = "Triggering"
    static var identifier = "GeofencesVC"
    
}

extension GeofencesVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let isRegionAnnotation = annotation.isKind(of: RegionAnnotation.self)
        if isRegionAnnotation {
            guard let regionAnnotation = annotation as? RegionAnnotation else { return nil }
            let annotationView = regionAnnotation.annotationView()
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.presenter?.userDidTapRegionSelected()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
            let title = annotation.title,
            let titleNotNil = title else { return }
        
        self.presenter?.userDidChooseRegion(with: titleNotNil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.fillColor = UIColor(
            red: 0,
            green: 0,
            blue: 1,
            alpha: 0.1
        )
        circleRenderer.lineWidth = 1
        
        return circleRenderer
    }
}
