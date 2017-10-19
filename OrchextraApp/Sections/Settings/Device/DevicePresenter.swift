//
//  DevicePresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation

protocol DeviceUI: class {
    
}

struct  DevicePresenter {
    
    // MARK: - Public attributes
    
    weak var view: DeviceUI?
    let wireframe: DeviceWireframe
    
    // MARK: - Input methods
    
    func viewDidLoad() {
        
    }
}
