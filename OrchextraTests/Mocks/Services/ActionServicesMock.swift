//
//  ActionServicesMock.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
@testable import Orchextra

class ActionServicesMock: ActionServicesInput {
    
    var spyConfirmAction: (called: Bool, action: Action)!
    
    func confirmAction(action: Action, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.spyConfirmAction = (called : true, action: action)
    }
}
