//
//  String+MD5.swift
//  Orchextra
//
//  Created by Judith Medina on 04/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {

    var md5: String? {
        return self.md5()
    }
}
