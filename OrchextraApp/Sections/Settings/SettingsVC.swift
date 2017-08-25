//
//  SettingsVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 23/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class SettingsVC: UIViewController, SettingsUI {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var apikeyTextfield: UITextField!
    @IBOutlet weak var apisecretTextfield: UITextField!
    @IBOutlet weak var userView: UITableViewCell!
    @IBOutlet weak var deviceView: UITableViewCell!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Attributtes
    
    var presenter: SettingsPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func stopButtonTapped(_sender: Any) {
        self.presenter?.userDidTapStop()
    }
    
    @IBAction func saveButtonTapped(_sender: Any) {
        self.presenter?.userDidTapSave()
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
