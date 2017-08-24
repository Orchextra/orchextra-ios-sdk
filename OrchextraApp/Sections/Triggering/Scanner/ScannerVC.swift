//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerVC: UIViewController, ScannerUI {
    
    // MARK: - Attributtes
    
    var presenter: ScannerPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
    }
}

extension ScannerVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Triggering"
    }
    
    public static func identifier() -> String? {
        return "ScannerVC"
    }
}
