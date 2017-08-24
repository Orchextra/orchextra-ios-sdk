//
//  Wireframe.swift
//  Orchextra
//
//  Created by Judith Medina on 24/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class Wireframe {
    
    func scannerOrx() -> ModuleInput? {
        let storyboard = UIStoryboard.init(name: "ScannerOrx", bundle: Bundle.OrxBundle())
        
        guard let scannerOrxVC = storyboard.instantiateViewController(withIdentifier: "ScannerVC") as? ModuleInput
            else {
                LogWarn("Couldn't instantiate ScannerOrxVC")
                return nil
        }
        return scannerOrxVC
    }
}
