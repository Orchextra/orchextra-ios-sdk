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
        let storyboard = UIStoryboard.init(name: "ScannerOrx", bundle: Bundle.orxBundle())
        guard let scannerOrxVC = storyboard.instantiateViewController(withIdentifier: "ScannerOrxVC") as? ModuleInput
            else {
                logWarn("Couldn't instantiate ScannerOrxVC")
                return nil
        }
        return scannerOrxVC
    }
    
    func defaultScanner() -> DefaultScannerModuleInput? {
        let storyboard = UIStoryboard.init(name: "DefaultScanner", bundle: Bundle.orxBundle())
        guard let scannerVC = storyboard.instantiateViewController(withIdentifier: "DefaultScannerVC") as? DefaultScannerModuleInput
            else {
                logWarn("Couldn't instantiate DefaultScannerVC")
                return nil
        }
        return scannerVC
    }
    
    // MARK: - Actions
    
    /// Open Browser
    ///
    /// - Parameter url:
    func openBrowser(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.application.presentModal(safariVC)
    }
    
    /// Open WebView
    ///
    /// - Parameter url:
    func openWebView(url: URL) {
        guard let webVC = try? WebVC.instantiateFromStoryboard() else {
            logWarn("WebVC not found")
            return }
        
        let presenter = WebPresenter(webView: webVC)
        webVC.presenter = presenter
        webVC.url = url

        let navigationController = UINavigationController(rootViewController: webVC)
        self.application.presentModal(navigationController)
    }
    
    /// Open Scanner
    ///
    /// - Parameter scanner:
    func openScanner(scanner: UIViewController) {
        let topVC = UIApplication.topViewController()
        
        if let topVCKindScanner = topVC.self, topVCKindScanner != scanner.self {
            self.application.presentModal(scanner)
        }
    }
    
    /// Open Browser External
    ///
    /// - Parameter url:
    func openBrowserExternal(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
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
