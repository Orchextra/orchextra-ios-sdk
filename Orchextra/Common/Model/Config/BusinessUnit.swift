//
//  BusinessUnit.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

public class BusinessUnit: Codable {
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public class func parse(businessUnitList: [String]?) -> [BusinessUnit] {
        guard let businessUnits = businessUnitList else {return [BusinessUnit]() }
        return businessUnits.map(businessUnit)
    }

    class func businessUnit(string: String) -> BusinessUnit {
        return BusinessUnit(name: string)
    }
}

extension BusinessUnit: Equatable {
    public static func == (lhs: BusinessUnit, rhs: BusinessUnit) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
