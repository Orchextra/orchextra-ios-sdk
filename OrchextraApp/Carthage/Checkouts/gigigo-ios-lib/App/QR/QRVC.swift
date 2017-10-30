//
//  QRVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary


class QRVC: UIViewController, UITextFieldDelegate, KeyboardAdaptable {
	
	@IBOutlet weak var textInput: UITextField!
	@IBOutlet weak var imageQR: UIImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	@IBAction func editingChanged(_ sender: AnyObject) {
		self.imageQR.image = nil
		guard let string = self.textInput.text else { return }
		
		QR.generate(string, onView: self.imageQR)
	}
}
