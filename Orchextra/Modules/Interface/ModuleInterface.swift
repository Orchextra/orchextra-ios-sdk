//
//  ModuleInterface.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol ModuleInput {
    func open()
    func stop()
}

protocol ModuleOutput {
    func triggerWasFire(with values: [String: Any], completion:(Bool, Error) -> Void)
}
