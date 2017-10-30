//
//  GIGMainAlert.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 2/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

protocol AlertInterface {
    func show()
    func addDefaultButton(_ title: String, usingAction:((String) -> Void)?)
    func addCancelButton(_ title: String, usingAction:((String) -> Void)?)
    func addDestructiveButton(_ title: String, usingAction:((String) -> Void)?)
}

open class Alert: NSObject {
    
    internal var interface: AlertInterface!
    
    internal override init() {
        interface = AlertController()
    }
    
    public init(title: String, message: String) {
        interface = AlertController(title: title, message: message)
    }
    
    open func show() {
        self.interface.show()
    }
    
    open func addDefaultButton(_ title: String, usingAction:((String) -> Void)?) {
        self.interface.addDefaultButton(title, usingAction: usingAction)
    }
    
    open func addCancelButton(_ title: String, usingAction:((String) -> Void)?) {
        self.interface.addCancelButton(title, usingAction: usingAction)
    }
    
    open func addDestructiveButton(_ title: String, usingAction:((String) -> Void)?) {
        self.interface.addDestructiveButton(title, usingAction: usingAction)

    }
}
