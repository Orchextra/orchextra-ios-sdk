//
//  LogsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol LogsPresenterInput {
    func viewWillAppear()
    func triggerListHasBeenUpdated()
    func tableViewNumberOfElements() -> Int
    func tableViewElements() -> [TriggerFired]
    func userDidTapFilters()
    func userDidTapClearFilters()
}

protocol LogsUI: class {
    func updateTriggerList()
    func showFilterInformation()
    func hideFilterInformation()
}

class LogsPresenter {
    
    // MARK: - Public attributes
    weak var view: LogsUI?
    let wireframe: LogsWireframe
    
    // MARK: - Interactors
    var interactor: LogsInteractorInput
    
    init(view: LogsUI,
         wireframe: LogsWireframe,
         interactor: LogsInteractorInput) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
    }
    
    // MARK: Private methods
    fileprivate func updateTriggerList() {
        let triggerListMustBeUpdated = TriggersManager.shared.triggerListMustBeUpdated
        if triggerListMustBeUpdated {
            self.view?.updateTriggerList()
        }
    }
    
    fileprivate func updateFilterView() {
        let filtersSelected = self.interactor.retrieveFiltersSelected()
        if filtersSelected.count > 0 {
            self.view?.showFilterInformation()
        } else {
            self.view?.hideFilterInformation()
        }
    }
    
    fileprivate func updateLogsView() {
        self.updateFilterView()
        self.updateTriggerList()
    }
}

extension LogsPresenter: LogsPresenterInput {
    func viewWillAppear() {
        self.updateLogsView()
    }
    
    func tableViewNumberOfElements() -> Int {
        let elements = self.interactor.retrieveTriggersLaunched()
        return elements.count
    }
    
    func tableViewElements() -> [TriggerFired] {
        let triggers = TriggersManager.shared.triggersFired
        return triggers
    }
    
    func triggerListHasBeenUpdated() {
        TriggersManager.shared.triggerListMustBeUpdated = false
    }
    
    func userDidTapFilters() {
        let filterInteractor = self.interactor.retrieveFiltersInteractor()
        self.wireframe.showFilterVC(with: filterInteractor)
    }
    
    func userDidTapClearFilters() {
        TriggersManager.shared.triggerListMustBeUpdated = true
        self.interactor.clearFiltersSelected()
        self.updateLogsView()
    }
}

extension LogsPresenter: LogsInteractorOutput {
    func filterInformationChanged() {
        self.updateLogsView()
    }
}
