//
//  XCUIElementExtension.swift
//  OrchextraAppCucumberTests
//
//  Created by Carlos Vicente on 7/12/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}
