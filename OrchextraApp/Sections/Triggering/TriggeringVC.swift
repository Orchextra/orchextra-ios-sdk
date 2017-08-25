//
//  TriggeringVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class TriggeringVC: UITabBarController, TriggeringUI {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Attributtes
    
    var presenter: TriggeringPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.presenter?.userDidTapSettings()
    }
}

extension TriggeringVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Triggering"
    }
    
    public static func identifier() -> String? {
        return "TriggeringVC"
    }
}
