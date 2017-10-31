//
//  GenderPickerView.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 23/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class GenderPickerVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var pickerView: UIPickerView!
    
    // MARK: Attributes
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
}

extension GenderPickerVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "GenderPickerVC"
}
