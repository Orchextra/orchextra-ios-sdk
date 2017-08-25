//
//  HomeVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class HomeVC: UIViewController {
    
    // MARK: - Attributtes
    
    var presenter: HomePresenterInput?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_sender: Any) {
        self.presenter?.userDidTapStart()
    }
    
    @IBAction func settingsButtonTapped(_sender: Any) {
        self.presenter?.userDidTapSettings()
    }
}

extension HomeVC: HomeUI {
    func showAlert(message: String) {
        let alert = Alert(title: "OrchextraApp", message: message)
        alert.addDefaultButton("OK", usingAction: nil)
        alert.show()
    }
}

extension HomeVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Home"
    }
    
    public static func identifier() -> String? {
        return "HomeVC"
    }
}
