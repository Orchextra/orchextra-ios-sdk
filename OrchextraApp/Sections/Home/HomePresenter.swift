//
//  HomePresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import Orchextra

protocol HomeUI: class {
     func showAlert(message: String)
     func initializeTextFieldTextsByDefault()
     func clearProjectNameInformation()
}

protocol HomePresenterInput {
    func viewDidLoad()
    func userDidTapStart(with apiKey: String?, apiSecret: String?)
    func userDidChangedCredentials()
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
        self.view?.initializeTextFieldTextsByDefault()
    }
    
    func userDidTapStart(with apiKey: String?, apiSecret: String?) {
        self.interactor.startOrchextra(with: apiKey, apiSecret: apiSecret)
    }
    
    func userDidChangedCredentials() {
         self.view?.clearProjectNameInformation()
    }
}

extension HomePresenter: HomeInteractorOutput {
    func startDidFinish(with result: Result<Bool, Error>) {
        switch result {
        case .success:
            print("Orchextra has been initialized correctly")
            AppController.shared.appWireframe?.showTriggering()
            
        case .error(let error):
            var message = ""
            switch error {
                case ErrorService.invalidCredentials:
                message = "Invalid Credentials"
                default:
                message = error.localizedDescription
            }
            self.view?.showAlert(message: message)
        }
    }
}
