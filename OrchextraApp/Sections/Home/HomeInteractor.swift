//
//  HomePresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

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
    let orchextraWrapper = OrchextraWrapperApp.shared
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
        
        self.orchextraWrapper.start(with: key, secret: secret) { result in
            self.output?.startDidFinish(with: result)
        }
    }
}
