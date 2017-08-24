//
//  GeofencesPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol GeofencesPresenterInput {
    func viewDidLoad()
}

protocol GeofencesUI: class {
    
}

struct GeofencesPresenter {
    
    // MARK: - Public attributes
    
    weak var view: GeofencesUI?
    let wireframe: GeofencesWireframe
    
    
}

extension GeofencesPresenter: GeofencesPresenterInput {
    func viewDidLoad() {
        
    }
}
