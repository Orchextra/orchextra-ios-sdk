//
//  StorageProximityMock.swift
//  OrchextraTests
//
//  Created by Judith Medina on 02/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
@testable import Orchextra

class StorageProximityMock: StorageProximityInput {

    var spySaveRegion: (called: Bool, region: RegionModelOrx)!
    var spyRemoveRegion: (called: Bool, region: RegionModelOrx)!
    var spyFindElement = (called: false, code: "")
    var spySaveRequestWaitTime = (called: false, rwt: 0)
    var spyLoadRequestWaitTime = (called: false, rwt: 0)
    var regionInput: RegionModelOrx?

    func saveRegion(region: RegionModelOrx) {
        self.spySaveRegion = (called: true, region: region)
    }
    
    func removeRegion(region: RegionModelOrx) {
        self.spyRemoveRegion = (called: true, region: region)
    }
    
    func findElement(code: String) -> RegionModelOrx? {
        self.spyFindElement.called = true
        self.spyFindElement.code = code
        return regionInput
    }
    
    func saveRequestWaitTime(rwt: Int) {
        self.spySaveRequestWaitTime.called = true
        self.spySaveRequestWaitTime.rwt = rwt
    }
    
    func loadRequestWaitTime() -> Int? {
        self.spyLoadRequestWaitTime.called = true
        return nil
    }
}
