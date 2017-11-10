//
//  DeviceVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class DeviceVC: UIViewController, DeviceUI {
    
    // MARK: - IBOutlets
    @IBOutlet weak var businessUnitsTextfield: UITextField!
    @IBOutlet weak var tagsTextfield: UITextField!
    
    // MARK: - Attributtes
    var presenter: DevicePresenter?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.title = "Device"
    }
}

extension DeviceVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "DeviceVC"
}

extension DeviceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tagsTextfield {
            if let tags = textField.text {
                self.presenter?.userDidSet(tags: tags)
            }
        } else if textField == self.businessUnitsTextfield {
            if let businessUnits = textField.text {
                self.presenter?.userDidSet(businessUnits: businessUnits)
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}
