//
//  Wireframe.swift
//  Orchextra
//
//  Created by Judith Medina on 24/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import SafariServices

class Wireframe {
    
    let application: Application
    
    init(application: Application) {
        self.application = application
    }
    
    func scannerOrx() -> ModuleInput? {
        let storyboard = UIStoryboard.init(name: "ScannerOrx", bundle: Bundle.OrxBundle())
        guard let scannerOrxVC = storyboard.instantiateViewController(withIdentifier: "ScannerVC") as? ModuleInput
            else {
                LogWarn("Couldn't instantiate ScannerOrxVC")
                return nil
        }
        return scannerOrxVC
    }
    
    
    // MARK: - Actions
    
    /// Open Browser
    ///
    /// - Parameter url:
    func openBrowser(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.application.presentModal(safariVC)
    }
    
    /// Open Scanner
    ///
    /// - Parameter scanner:
    func openScanner(scanner: UIViewController) {
        self.application.presentModal(scanner)
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
