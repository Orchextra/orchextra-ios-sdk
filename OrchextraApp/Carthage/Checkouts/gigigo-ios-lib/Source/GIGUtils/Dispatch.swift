//
//  Dispatch.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//


import Foundation

public func gig_dispatch_background(_ code: @escaping () -> Void) {
	DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: code)
}

public func gig_dispatch_main(_ code: @escaping () -> Void) {
	DispatchQueue.main.async(execute: code) 
}

public func gig_dispatch_main_after(_ seconds: UInt64, code: @escaping () -> Void) {
	let popTime = DispatchTime.now() + Double((Int64)(seconds * NSEC_PER_SEC)) / Double(NSEC_PER_SEC);
	DispatchQueue.main.asyncAfter(deadline: popTime, execute: code);
}
