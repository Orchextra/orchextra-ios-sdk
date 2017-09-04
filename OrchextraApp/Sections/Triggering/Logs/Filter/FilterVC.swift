//
//  FilterVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class FilterVC: UIViewController, FilterUI {
    
    // MARK: - Attributtes
    
    var presenter: FilterPresenter?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
}

extension FilterVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return ""
    }
    
    public static func identifier() -> String? {
        return "FilterVC"
    }
}
