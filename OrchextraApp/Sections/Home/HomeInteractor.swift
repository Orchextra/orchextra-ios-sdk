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

enum StartError: Error {
    case credentialsNil
}

protocol HomeInteractorInput {
    func startOrchextra(with apiKey: String?, apiSecret: String?)
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
    func startOrchextra(with apiKey: String?, apiSecret: String?) {
        guard let key = apiKey,
        let secret = apiSecret else {
            let error = StartError.credentialsNil
            let result = Result<Bool, Error>.error(error)
            self.output?.startDidFinish(with: result)
            
            return
        }
        
        self.orchextra.logLevel = .debug
        self.orchextra.logStyle = .funny
        self.orchextra.environment = .quality
        
        // TODO: get data from SDK and if it is nil set default project credentials
        
        self.orchextra.start(with: key, apiSecret: secret) { result in
            self.output?.startDidFinish(with: result)
        }
    }
}
