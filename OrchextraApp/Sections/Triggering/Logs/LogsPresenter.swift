//
//  LogsPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol LogsPresenterInput {
    func viewDidLoad()
}

protocol LogsUI: class {
    
}

struct LogsPresenter {
    
    // MARK: - Public attributes
    
    weak var view: LogsUI?
    let wireframe: LogsWireframe
}

extension LogsPresenter: LogsPresenterInput {
    func viewDidLoad() {
        
    }
}
