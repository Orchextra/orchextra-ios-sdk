//
//  ModuleMock.swift
//  OrchextraApp
//
//  Created by Judith Medina on 12/12/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import Orchextra

class ModuleMock: UIViewController, ModuleInput {
    var outputModule: ModuleOutput?
    
    func start() {
        
    }
    
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        if let completion = completionHandler {
            completion()
        }
    }
}
