//
//  UserInteractor.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 18/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol UserInteractorInput {
   
}

protocol UserInteractorOutput {
    
}

struct UserInteractor {
    
    // MARK: - Attributes
    var output: UserInteractorOutput?
}

extension UserInteractor: UserInteractorInput {
    
}
