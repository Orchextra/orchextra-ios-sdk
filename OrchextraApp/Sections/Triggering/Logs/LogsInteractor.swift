//
//  LogsInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol LogsInteractorInput {
    func fetchTriggersLaunched() -> [TriggerFired]
}

protocol LogsInteractorOutput {
    
}

struct LogsInteractor {
    // MARK: - Attributes
    
    var output: LogsInteractorOutput?
    let orchextraWrapper = OrchextraWrapper.shared
}

extension LogsInteractor: LogsInteractorInput {
    func fetchTriggersLaunched() -> [TriggerFired] {
        return TriggersManager.shared.retrieveTriggersFired()
    }
}
