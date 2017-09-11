//
//  TriggeringPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UIKit

protocol TriggeringPresenterInput {
    func viewDidLoad()
    func userDidTapSettings()
    func userDidTapTabBarItem()
}

protocol TriggeringUI: class {
    func initializeTabBarItems(with items: [UIViewController])
    func setTitleForSelectedItem()
}

struct TriggeringPresenter {
    
    // MARK: - Public attributes
    
    weak var view: TriggeringUI?
    let wireframe: TriggeringWireframe
    
    // MARK: - Interactors
    
    let interactor: TriggeringInteractor
}

extension TriggeringPresenter: TriggeringPresenterInput {
    func viewDidLoad() {
        let viewControllers = self.wireframe.showTriggeringViewControllers()
        self.view?.initializeTabBarItems(with: viewControllers)
    }
    
    func userDidTapSettings() {
        self.wireframe.showSettings()
    }
    
    func userDidTapTabBarItem() {
        self.view?.setTitleForSelectedItem()
    }

}
