//
//  MenuSection.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class MenuSection {
    
    open let name: String
    open let icon: UIImage
    open let storyboard: String
    open let viewController: String?
    open var modeButtonType: Bool?
    open var completionButtonType: (() -> Void)?
    
    lazy var sectionController: UIViewController = self.instantiateViewController()
    
    
    public init(name: String, icon: UIImage, storyboard: String, viewController: String? = nil, modeButtonType: Bool? = nil,  completionButtonType: (() -> Void)? = nil) {
        self.name = name
        self.icon = icon
        self.storyboard = storyboard
        self.viewController = viewController
        self.modeButtonType = modeButtonType
        self.completionButtonType = completionButtonType
    }
    
    
    fileprivate func instantiateViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
        let sectionVC: UIViewController
        
        if let viewControllerName = self.viewController {
            sectionVC = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        }
        else {
            sectionVC = storyboard.instantiateInitialViewController()!
        }
        
        return sectionVC
    }
    
}
