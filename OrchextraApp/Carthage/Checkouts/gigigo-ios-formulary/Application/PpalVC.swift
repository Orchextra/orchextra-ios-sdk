//
//  PpalVC.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 17/1/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class PpalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Actions
    
    @IBAction func navigateToThirdVC(_ sender: Any) {        
        guard let formVC = self.showLoginForm() else { return }
        self.show(formVC, sender: nil)
    }
    
    // MARK: Private Method
    
    func showLoginForm() -> UIViewController? {
        guard let formVC = try? ThirdTypeVC.instantiateFromStoryboard() else {
            LogWarn("ThirdTypeVC not found")
            return nil
        }

        let loginFormNavigation = UINavigationController(rootViewController: formVC)
        loginFormNavigation.navigationBar.appareanceJanrain()
        return loginFormNavigation
    }
}

extension UINavigationBar {
    func appareanceJanrain() {
        self.barTintColor = UIColor.red
        self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
