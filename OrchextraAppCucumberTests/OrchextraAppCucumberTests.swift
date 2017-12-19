//
//
//  Created by XCFit Framework
//  Copyright © 2017 XCFit Framework. All rights reserved.
//


/*

 This is sample code created by XCFit Framework and can be edited/Removed as needed.
 
 This is very important file as we will be using it as initialiser of all out test suite. We have to resgister all our Step Definitions in this class. e.g we have registed CommonStepDefinitions and HomeScreenSteps here

 */


import Foundation
import Cucumberish

@objc class OrchextraAppCucumberTests: NSObject {
    @objc class func CucumberishSwiftInit()
    {
        let application : XCUIApplication = XCUIApplication()
        //A closure that will be executed just before executing any of your features
        beforeStart { () -> Void in
            HomeScreenSteps().HomeScreenSteps()
            ScannerScreenSteps().scannerScreenSteps()

        }
        
        before{ (_ )  -> Void in
            LoginScreenSteps().testLoginScreenWithInvalidCredentials()
        }
        
        //A Given step definition
        Given("the app is running") { (args, userInfo) -> Void in
            application.launch()

        }
        let bundle = Bundle(for: OrchextraAppCucumberTests.self)

        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
