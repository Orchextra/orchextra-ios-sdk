//
//  BusinessUnit.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

public struct BusinessUnit: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    public init(name: String) {
        self.name = name
    }
    
    // MARK: - Encodable Protocol
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
    }

    // MARK: - Decodable Protocol
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)

        self.init(name: name)
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
