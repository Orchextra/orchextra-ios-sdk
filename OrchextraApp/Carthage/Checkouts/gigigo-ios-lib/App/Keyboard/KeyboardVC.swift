//
//  KeyboardVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 8/5/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary


class KeyboardVC: UIViewController, KeyboardAdaptable {

	@IBOutlet weak var labelHidden: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.startKeyboard()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.stopKeyboard()
		
		super.viewWillDisappear(animated)
	}
	
	
	// MARK: - Keyboard
	
	func keyboardWillShow() {
		self.labelHidden.alpha = 0
	}
	
	func keyboardWillHide() {
		self.labelHidden.alpha = 1
	}


	@IBAction func onButtonTap(_ sender: AnyObject) {
		self.view.endEditing(true)
	}
	
	
}
