//
//  TriggeringVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class TriggeringVC: UITabBarController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Attributtes
    
    var presenter: TriggeringPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.initializeSubviews()
        self.view.accessibilityIdentifier = "TriggeringVC"
        self.settingsButton.accessibilityIdentifier = "settingsButton"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - Utils
    
    private func initializeSubviews() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBar.tintColor = UIColor.ORXApp.coral
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.presenter?.userDidTapSettings()
    }
    
    
    
    // MARK: - UITabBarDelegate methods
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       self.presenter?.userDidTapTabBarItem()
    }
}

extension TriggeringVC: TriggeringUI {
    func initializeTabBarItems(with items: [UIViewController]) {
        self.viewControllers = items
        self.setTitleForSelectedItem()
    }
    
    func setTitleForSelectedItem() {
        let tabBarItems = self.tabBar.items
        let firstItem = tabBarItems?[0]
        let title = self.tabBar.selectedItem?.title ?? firstItem?.title
        self.title = title
    }
}

extension TriggeringVC: Instantiable {
    
    // MARK: - Instantiable
    
    static var storyboard = "Triggering"
    static var identifier = "TriggeringVC"
    
}
