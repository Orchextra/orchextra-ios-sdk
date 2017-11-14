//
//  DeviceVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class DeviceVC: UIViewController {
    
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
    
    @IBAction func saveTapped(_ sender: Any) {
        self.presenter?.userDidTappedSave(
            tags: self.tagsTextfield.text,
            businessUnit: self.businessUnitsTextfield.text)
        
        self.tagsTextfield.resignFirstResponder()
        self.businessUnitsTextfield.resignFirstResponder()
    }
}

extension DeviceVC: DeviceUI {
    
    func showDevice(tags: String) {
        self.tagsTextfield.text = tags
    }
    
    func showDevice(businessUnit: String) {
        self.businessUnitsTextfield.text = businessUnit
    }
}

extension DeviceVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "DeviceVC"
}
