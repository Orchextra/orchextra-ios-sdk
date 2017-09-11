//
//  SettingsVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class SettingsVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectTextfield: UITextField!
    @IBOutlet weak var apiKeyLabel: UILabel!
    @IBOutlet weak var apiKeyTextfield: UITextField!
    @IBOutlet weak var apiSecretLabel: UILabel!
    @IBOutlet weak var apiSecretTextfield: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Attributtes
    
    var presenter: SettingsPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBActions
    
    @IBAction func logOutButtonTapped(_sender: Any) {
        self.presenter?.userDidTapLogOut()
    }
    
    @IBAction func editButtonTapped(_sender: Any) {
        self.presenter?.userDidTapEdit()
    }
}

extension SettingsVC: SettingsUI {
    func initializeSubviews(with projectName: String, apiKey: String, apiSecret: String, editable: Bool) {
        self.title = "Settings"
        
        self.projectTextfield.text = projectName
        self.apiKeyTextfield.text = apiKey
        self.apiSecretTextfield.text = apiSecret
        
        self.projectTextfield.isUserInteractionEnabled = editable
        self.apiKeyTextfield.isUserInteractionEnabled = editable
        self.apiSecretTextfield.isUserInteractionEnabled = editable
        
        self.apiKeyTextfield.adjustsFontSizeToFitWidth = true
        self.apiSecretTextfield.adjustsFontSizeToFitWidth = true
        
        self.apiKeyTextfield.minimumFontSize = 8.0
        self.apiSecretTextfield.minimumFontSize = 8.0
    }
    
    func updateEditableState(title: String) {
        self.apiKeyTextfield.isUserInteractionEnabled = true
        self.apiSecretTextfield.isUserInteractionEnabled = true
        self.apiKeyTextfield.textColor = UIColor.black
        self.apiSecretTextfield.textColor = UIColor.black
        self.editButton.title = title
    }
    
    func updateNotEditableState(title: String) {
        self.apiKeyTextfield.isUserInteractionEnabled = false
        self.apiSecretTextfield.isUserInteractionEnabled = false
        self.apiKeyTextfield.textColor = UIColor.ORXApp.gray
        self.apiSecretTextfield.textColor = UIColor.ORXApp.gray
        self.editButton.title = title
    }
}

extension SettingsVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Settings"
    }
    
    public static func identifier() -> String? {
        return "SettingsVC"
    }
}
