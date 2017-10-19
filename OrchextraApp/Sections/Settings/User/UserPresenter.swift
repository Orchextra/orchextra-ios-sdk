//
//  UserPresenterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import Foundation

protocol UserPresenterInput {
    func saveButtonTapped()
}

protocol UserUI: class {
}

struct  UserPresenter {
    
    // MARK: - Public attributes
    
    weak var view: UserUI?
    let wireframe: UserWireframe
    
    // MARK: - Input methods
    func viewDidLoad() {
        
    }
}

extension UserPresenter: UserPresenterInput {
    func saveButtonTapped() {
        
    }
}
