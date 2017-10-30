//
//  StringExtension.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 23/11/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public extension String {
	
	public static func base64(_ string: String) -> String? {
		return string.data(using: .utf8).map { $0.base64EncodedString() }
	}
	
	public func toBase64() -> String? {
		return String.base64(self)
	}
	
}
