//
//  ORCActionInterfaceMock.swift
//  Orchextra
//
//  Created by Carlos Vicente on 19/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import Orchextra

class ORCACtionInterfaceMock: NSObject {
    //MARK Properties
    var didFireTriggerCalled: Bool                      = false
    var didFireTriggerFromViewControllerCalled: Bool    = false
    var presentToViewControllerCalled: Bool             = false
    var presentActionCalled: Bool                       = false
    var pushActionCalled: Bool                          = false
    var topViewControllerCalled: Bool                   = false
    var viewControllerToBePresentedIsTopViewController  = false
}

extension ORCACtionInterfaceMock: ORCActionInterface {
    
    func didFireTrigger(with action: ORCAction!) {
        self.didFireTriggerCalled = true
    }
    
    func didFireTrigger(with action: ORCAction!, from viewController: UIViewController!) {
        self.didFireTriggerFromViewControllerCalled = true
    }
    
    func present(_ toViewController: UIViewController!) {
        self.presentToViewControllerCalled = true
    }
    
    func presentAction(withCustomScheme customScheme: String!) {
        self.presentActionCalled = true
    }
    
    func pushAction(to toViewController: UIViewController!) {
        self.pushActionCalled = true
    }
    
    func topViewController() -> UIViewController! {
        self.topViewControllerCalled = true
        return UIViewController()
    }
    
    func viewController(toBePresented viewControllerToBePresented: UIViewController!, isEqualToTopViewController topViewController: UIViewController!) -> Bool {
        self.viewControllerToBePresentedIsTopViewController  = false
        return true
    }

}
