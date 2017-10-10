//
//  BusinessUnit.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

struct BusinessUnit: Codable {
    let name: String
}

extension BusinessUnit: Equatable {
    static func == (lhs: BusinessUnit, rhs: BusinessUnit) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
