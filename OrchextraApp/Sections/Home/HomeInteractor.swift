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

protocol HomeInteractorInput {
    func startOrchextra()
}

protocol HomeInteractorOutput {
    func startDidFinish(with result: Result<Bool, Error>)
}

class HomeInteractor {
     // MARK: - Attributes
    
    var output: HomeInteractorOutput?
    let orchextra = Orchextra.shared
}

extension HomeInteractor: HomeInteractorInput {
    func startOrchextra() {
        self.orchextra.logLevel = .debug
        self.orchextra.logStyle = .funny
        self.orchextra.environment = .quality
        
        // TODO: get data from SDK and if it is nil set default project credentials
        
        self.orchextra.start(with: Constants.apiKey, apiSecret: Constants.apiSecret) { result in
            self.output?.startDidFinish(with: result)
        }
    }
}
