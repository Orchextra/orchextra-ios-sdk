//
//  GIGAlertViewController.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 17/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary

class GIGAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let alert = Alert(title: "Alert titulo", message: "Mensaje")
        alert.addDefaultButton("Default") { (title) -> Void in
            print("Default button")
        }
		
        alert.addCancelButton("Cancel", usingAction: nil)
		
        alert.addDestructiveButton("Destructive") { (title) -> Void in
            print("Destructive button")
        }
        
        alert.show()
    }
}
