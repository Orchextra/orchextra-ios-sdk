//
//  CBCentralWrapperMock.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation
import CoreBluetooth

@testable import Orchextra

class CBCentralWrapperMock: CBCentralWrapper {
    
   override func initializeCentralManager() {
        
        let centralManager = CBCentralManager(delegate: self,
                                              queue:self.centralManagerQueue,
                                              options: nil)
        
        self.centralManager = centralManager
    }
}
