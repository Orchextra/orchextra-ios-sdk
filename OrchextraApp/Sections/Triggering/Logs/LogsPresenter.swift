//
//  LogsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol LogsPresenterInput {
    func viewDidLoad()
    func viewWillAppear()
    func triggerListHasBeenUpdated()
    func tableViewNumberOfElements() -> Int
    func tableViewElements() -> [Trigger]
}

protocol LogsUI: class {
    func updateTriggerList()
}

struct LogsPresenter {
    
    // MARK: - Public attributes
    
    weak var view: LogsUI?
    let wireframe: LogsWireframe
    
    // MARK: - Interactors
    
    let interactor: LogsInteractorInput
    
    // MARK: Private methods
    fileprivate func updateTriggerList() {
        let triggerListMustBeUpdated = TriggersManager.shared.triggerListMustBeUpdated
        if triggerListMustBeUpdated {
            self.view?.updateTriggerList()
        }
    }
}

extension LogsPresenter: LogsPresenterInput {
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        self.updateTriggerList()
    }
    
    func tableViewNumberOfElements() -> Int {
        let elements = self.interactor.fetchTriggersLaunched()
        return elements.count
    }
    
    func tableViewElements() -> [Trigger] {
        let triggers = TriggersManager.shared.triggersFired
        return triggers
    }
    
    func triggerListHasBeenUpdated() {
        TriggersManager.shared.triggerListMustBeUpdated = false
    }
}
