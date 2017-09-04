//
//  ProximityWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

class ProximityWrapper: ModuleInput {
    
    var outputModule: ModuleOutput?
    
    // MARK: - Module Input methods
    
    // Start monitoring the regions
    func start() {
        
    }
    
    /// Finish monitoring services
    ///
    /// - Parameters:
    ///   - action: which has started the finish flow.
    ///   - completionHandler: let know the integrative app that the services is finished.
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        
    }
    
    /// Set regions for the proximity module
    ///
    /// - Parameter config: 
    func setConfig(config: [String : Any]) {
        
    }
}
