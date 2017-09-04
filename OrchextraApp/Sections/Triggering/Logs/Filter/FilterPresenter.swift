//
//  FilterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol FilterUI: class {
    
}

struct FilterPresenter {
    
    // MARK: - Public attributes
    
    weak var view: FilterUI?
    let wireframe: FilterWireframe
    
    // MARK: - Interactors
    
    let interactor: FilterInteractor
    
    // MARK: - Input methods
    
    func viewDidLoad() {
        
    }
}
