//
//  Result.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 19/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

public enum Result<SuccessType, ErrorType> {
	
	case success(SuccessType)
	case error(ErrorType)
	
}
