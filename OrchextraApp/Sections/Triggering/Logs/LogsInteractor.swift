//
//  LogsInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol LogsInteractorInput {
    func fetchTriggersLaunched() -> [Trigger]
}

protocol LogsInteractorOutput {
    
}

struct LogsInteractor {
    // MARK: - Attributes
    
    var output: LogsInteractorOutput?
    let orchextraWrapper = OrchextraWrapper.shared
}

extension LogsInteractor: LogsInteractorInput {
    func fetchTriggersLaunched() -> [Trigger] {
        return TriggersManager.shared.retrieveTriggersFired()
    }
}
