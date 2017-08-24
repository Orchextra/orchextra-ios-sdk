//
//  TriggeringPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol TriggeringPresenterInput {
    func viewDidLoad()
}

protocol TriggeringUI: class {
    
}

struct TriggeringPresenter {
    
    // MARK: - Public attributes
    
    weak var view: TriggeringUI?
    let wireframe: TriggeringWireframe
    
    // MARK: - Interactors
    
    let interactor: TriggeringInteractor
}

extension TriggeringPresenter: TriggeringPresenterInput {
    func viewDidLoad() {
        
    }

}
