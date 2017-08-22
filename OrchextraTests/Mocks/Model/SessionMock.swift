//
//  SessionMock.swift
//  Orchextra
//
//  Created by Judith Medina on 17/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra


class SessionMock: Session {
    
    override func loadAccesstoken() -> String? {
        return nil
    }

}
