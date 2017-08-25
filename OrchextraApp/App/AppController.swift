//
//  AppController.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

class AppController {
    
    static let shared = AppController()
    var appWireframe: AppWireframe?
    
    func appDidLaunch() {
        self.appWireframe?.showHomeWireframe()
    }
    
}
