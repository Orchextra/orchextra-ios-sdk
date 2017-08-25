//
//  HomePresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol HomeUI: class {
     func showAlert(message: String)
}

protocol HomePresenterInput {
    func viewDidLoad()
    func userDidTapStart()
    func userDidTapSettings()
}

struct HomePresenter {
    
    // MARK: - Public attributes
    
    weak var view: HomeUI?
    let wireframe: HomeWireframe
    
    // MARK: - Interactors
    
    let interactor: HomeInteractorInput
}

extension HomePresenter: HomePresenterInput {
    func viewDidLoad() {
        
    }
    
    func userDidTapStart() {
        self.interactor.startOrchextra()
    }
    
    func userDidTapSettings() {
        AppController.shared.appWireframe?.showSettings()
    }
}

extension HomePresenter: HomeInteractorOutput {
    func startDidFinish(with result: Result<Bool, Error>)  {
        switch result {
        case .success:
            print("Orchextra has been initialized correctly")
            AppController.shared.appWireframe?.showTriggering()
            
        case .error(let error):
            self.view?.showAlert(message: error.localizedDescription)
        }
        
    }
}
