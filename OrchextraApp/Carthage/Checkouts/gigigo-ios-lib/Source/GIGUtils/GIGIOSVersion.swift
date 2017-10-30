//
//  GIGIOSVersion.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 3/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

let Device = UIDevice.current
let iosVersion = NSString(string: Device.systemVersion).doubleValue

let MAJORTHANIOS8 = (iosVersion > 8.0)
let iOS7 = (iosVersion < 8)
