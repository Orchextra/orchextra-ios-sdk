//
//  InfoPlist.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 26/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public func InfoDictionary(_ key: String) -> String {
	guard let constant = Bundle.main.infoDictionary?[key] as? String else {
		return "CONSTANT NOT FOUND"
	}
	
	return constant
}
