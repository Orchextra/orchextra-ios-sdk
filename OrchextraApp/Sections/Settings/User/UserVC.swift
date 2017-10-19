//
//  UserVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class UserVC: UIViewController, UserUI {
    
    // MARK: - Attributtes
    
    var presenter: UserPresenter?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        self.title = "User"
    }
}

extension UserVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "UserVC"
}
