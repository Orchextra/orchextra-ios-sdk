//
//  File.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 1/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
open class AlertController: NSObject, AlertInterface {
    
    var alert: UIAlertController
    
    public override init() {
        self.alert = UIAlertController()
    }
    
    public init(title: String, message: String) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    internal init(title: String, message: String, style:UIAlertControllerStyle) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: style)
    }
    
    open func show() {
		Application().presentModal(self.alert)
    }
    
    open func addDefaultButton(_ title: String, usingAction:((String) -> Void)?) {
        let action = UIAlertAction(title: title, style: .default) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
    
    open func addCancelButton(_ title: String, usingAction:((String) -> Void)?) {
        let action = UIAlertAction(title: title, style: .cancel) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
    
    open func addDestructiveButton(_ title: String, usingAction:((String) -> Void)?) {
        let action = UIAlertAction(title: title, style: .destructive) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
}
