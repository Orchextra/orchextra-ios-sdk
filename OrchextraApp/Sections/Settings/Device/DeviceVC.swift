//
//  DeviceVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class DeviceVC: UIViewController, DeviceUI {
    
    // MARK: - Attributtes
    
    var presenter: DevicePresenter?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        self.title = "Device"
    }
}

extension DeviceVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "DeviceVC"
}
