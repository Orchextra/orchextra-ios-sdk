//
//  GeofencesVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class GeofencesVC: UIViewController, GeofencesUI {
    
    // MARK: - Attributtes
    
    var presenter: GeofencesPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
    }
}

extension GeofencesVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Triggering"
    }
    
    public static func identifier() -> String? {
        return "GeofencesVC"
    }
}
