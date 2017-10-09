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
        if let running = Session.shared.isOrchextraRunning(),
            running == true {
            OrchextraWrapper.shared.start(with: Constants.apiKey, secret: Constants.apiSecret, completion: { result in
                switch result {
                case .success:
                    self.appWireframe?.showTriggering()
                case .error:
                    self.appWireframe?.showHomeWireframe()
                }
            })
        } else {
            self.appWireframe?.showHomeWireframe()
        }
    }
}
