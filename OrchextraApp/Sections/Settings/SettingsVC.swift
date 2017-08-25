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
    
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: - Attributtes
    
    var presenter: SettingsPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    @IBAction func stopButtonTapped(_sender: Any) {
        self.presenter?.userDidTapStop()
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
