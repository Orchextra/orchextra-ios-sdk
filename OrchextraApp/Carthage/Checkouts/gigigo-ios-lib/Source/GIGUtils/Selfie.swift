//
//  Selfie.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 28/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public protocol Selfie: CustomStringConvertible {}

public extension Selfie {
	var description: String {
		let mirror = Mirror(reflecting: self)
		return "\(mirror.subjectType)( \(mirror.children.map({ "\($0!): \($1) "}).joined(separator: ", ")))"
	}
}
