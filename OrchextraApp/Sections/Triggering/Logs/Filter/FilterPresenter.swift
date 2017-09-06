//
//  FilterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol FilterPresenterInput {
    func viewDidLoad()
    func userDidTap(filter: Filter, at position: Int)
    func userDidTapFilter(at index: Int)
    func userDidTapCancel()
    func userDidTapSave()
    func tableViewNumberOfElements() -> Int
    func tableViewElements() -> [Filter]
}

protocol FilterUI: class {
    func reloadFilter(at position: Int)
}

struct FilterPresenter {
    // MARK: - Public attributes
    
    weak var view: FilterUI?
    let wireframe: FilterWireframe
    
    // MARK: - Interactors
    
    var interactor: FilterInteractorInput
}

extension FilterPresenter: FilterPresenterInput {
    func viewDidLoad() {
    }
    
    func userDidTap(filter: Filter, at position: Int) {
       self.interactor.update(filter: filter, at: position)
       self.view?.reloadFilter(at: position)
    }
    
    func userDidTapFilter(at index: Int) {
        let filters = self.interactor.retrieveFilters()
        let filter = filters[index]
        self.interactor.update(filter: filter, at: index)
        self.view?.reloadFilter(at: index)
    }
    
    func userDidTapCancel() {
        self.wireframe.dismissFilterVC()
    }
    
    func userDidTapSave() {
        TriggersManager.shared.triggerListMustBeUpdated = true
        self.wireframe.dismissFilterVC()
    }
    
    func tableViewNumberOfElements() -> Int {
        let availableFilters = self.interactor.retrieveFilters()
        return availableFilters.count
    }
    
    func tableViewElements() -> [Filter] {
        return self.interactor.retrieveFilters()
    }
}

extension FilterPresenter: FilterInteractorOutput {
    func filterUpdated(at position: Int) {
        self.view?.reloadFilter(at: position)
    }
}
