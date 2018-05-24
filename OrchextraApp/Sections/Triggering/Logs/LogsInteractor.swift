//
//  LogsInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol LogsInteractorInput {
    func retrieveTriggersLaunched() -> [TriggerFired]
    func retrieveFiltersSelected() -> [Filter]
    func clearFiltersSelected()
    func retrieveFiltersInteractor() -> FilterInteractor
}

protocol LogsInteractorOutput {
    func filterInformationChanged()
}

class LogsInteractor {
    // MARK: - Attributes
    var output: LogsInteractorOutput?
    var filterInteractor: FilterInteractor
    
    // MARK: - Initializer
    init(filterInteractor: FilterInteractor) {
        self.filterInteractor = filterInteractor
    }
}

extension LogsInteractor: LogsInteractorInput {
    func retrieveTriggersLaunched() -> [TriggerFired] {
        let filtersSelected = self.retrieveFiltersSelected()
        let triggersFired = TriggersManager.shared.retrieveTriggersFired()
        var triggersFiltered: [TriggerFired] = triggersFired
        
        filtersSelected.forEach { (filter) in
            triggersFiltered = triggersFired.filter { (trigger) in
                let filterFound = (trigger.trigger.triggerId == filter.id)
                return filterFound
            }
        }
        
        return triggersFiltered
    }
    
    func retrieveFiltersSelected() -> [Filter] {
        let filters = self.filterInteractor.retrieveFilters()
        let filtersSelected: [Filter] = (filters.filter { ($0.selected == true)
            })
        
        return filtersSelected
    }
    
    func clearFiltersSelected() {
       self.filterInteractor.clearSelectedFilters()
    }
    
    func retrieveFiltersInteractor() -> FilterInteractor {
        return self.filterInteractor
    }
}
