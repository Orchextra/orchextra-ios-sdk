//
//  Filter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 5/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

class Filter {
    let id: String
    let name: String
    let index: Int
    var selected: Bool
    
    init(id: String, name: String, index: Int, selected: Bool) {
        self.id = id
        self.name = name
        self.index = index
        self.selected = selected
    }
}
