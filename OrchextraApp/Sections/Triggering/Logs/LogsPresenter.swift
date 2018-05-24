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
    func viewDidLoad()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .logsTriggerNeedsTobeUpdated, object: nil)
    }
    
    // MARK: Private methods
    @objc fileprivate func updateTriggerList() {
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
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTriggerList),
                                               name: .logsTriggerNeedsTobeUpdated, object: nil)
    }
    
    func tableViewNumberOfElements() -> Int {
        let elements = self.interactor.retrieveTriggersLaunched()
        return elements.count
    }
    
    func tableViewElements() -> [TriggerFired] {
        let elements = self.interactor.retrieveTriggersLaunched()
        return elements
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
