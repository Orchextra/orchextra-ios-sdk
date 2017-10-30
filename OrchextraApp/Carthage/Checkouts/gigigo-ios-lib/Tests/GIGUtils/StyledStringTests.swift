//
//  StyledStringTests.swift
//  GiGLibrary
//
//  Created by Sergio López on 2/8/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
import GIGLibrary

class StyledStringTests: XCTestCase {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func setUp() {
        super.setUp()
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func test_applySyles_preservesText()
    {
        self.label.styledString = "texto".style(.color(UIColor.red))
        XCTAssert(self.label.attributedText?.string == "texto")
    }
    
    func test_applySyles_should_concatenate_text()
    {
        self.label.styledString = "texto" + " texto2" + " texto3".style(.color(UIColor.red))
        XCTAssert(self.label.attributedText?.string == "texto texto2 texto3")
    }
    
    func test_applySyles_should_concatenate_Styles()
    {
        self.label.styledString = "texto" + " texto2".style(.color(UIColor.blue)) + " texto3".style(.color(UIColor.red))
        XCTAssert(self.label.attributedText?.string == "texto texto2 texto3")
    }
    
    func test_applySyles_should_concatenate_StyleFirstAndTextSecond()
    {
        self.label.styledString = "texto ".style(.color(UIColor.blue)) + "texto2"
        XCTAssert(self.label.attributedText?.string == "texto texto2")
    }
    
    func test_applySyles_should_concatenate_textFirstAndStyleSecond()
    {
        self.label.styledString =  "texto" + " texto2".style(.color(UIColor.blue))
        XCTAssert(self.label.attributedText?.string == "texto texto2")
    }
    
    func test_applySyles_shouldSetRedText() {
     
        self.label.styledString = "texto" + "rojo".style(.color(UIColor.red))
        
		let firstWordcolor = self.label.attributedText?.attribute(named:NSAttributedStringKey.foregroundColor.rawValue, forText:"texto")
		let secondWordcolor = self.label.attributedText?.attribute(named:NSAttributedStringKey.foregroundColor.rawValue, forText:"rojo") as! UIColor
        
        XCTAssert(firstWordcolor == nil)
        XCTAssert(secondWordcolor == UIColor.red)
    }
    
    func test_applySyles_shouldSetRedTextAndUnderlinedText() {
        
        self.label.styledString = "texto" + "subrayado".style(.color(UIColor.red), .underline)
        
		let color = self.label.attributedText?.attribute(named: NSAttributedStringKey.foregroundColor.rawValue, forText: "subrayado") as! UIColor
		let underlineStyle = self.label.attributedText?.attribute(named: NSAttributedStringKey.underlineStyle.rawValue, forText: "subrayado")

        XCTAssert(color == UIColor.red)
        XCTAssert(underlineStyle != nil)
    }
    
    func test_applySyles_shouldSetBackgroundColor() {
        
        self.label.styledString = "texto" + "con background".style(.backgroundColor(UIColor.red))
        
		let backgroundColor = self.label.attributedText?.attribute(named: NSAttributedStringKey.backgroundColor.rawValue, forText: "con background") as! UIColor
        
        XCTAssert(equalColors(backgroundColor, c2: UIColor.red))
    }
    
    func test_applySyles_shouldSetRightFont() {
        
        let font = UIFont(name: "ChalkboardSE-Light", size: 15)!
        self.label.styledString = "texto" + "con background".style(.font(font))
        
		let resultFont = self.label.attributedText?.attribute(named: NSAttributedStringKey.font.rawValue, forText: "con background") as! UIFont
        
        XCTAssert(resultFont == font)
    }
    
    func test_chanceInFontDoesNotAffectNextStrings() {
        
        let newFont = UIFont(name: "ChalkboardSE-Light", size: 15)!
        self.label.styledString = "texto con " + "fuente1".style(.fontName("ChalkboardSE-Light")) + "y texto con " + "fuente por defecto"

		let changedFont = self.label.attributedText?.attribute(named: NSAttributedStringKey.font.rawValue, forText: "fuente1") as! UIFont
		let defaultFont = self.label.attributedText?.attribute(named: NSAttributedStringKey.font.rawValue, forText: "fuente por defecto")

        XCTAssert(changedFont.fontName == newFont.fontName)
        XCTAssert(defaultFont == nil)
    }
    
    func test_applySyles_shouldSetBoldColor() {
        
        self.label.styledString = "texto" + "con background".style(.bold)
        
		let font = self.label.attributedText?.attribute(named: NSAttributedStringKey.font.rawValue, forText: "con background") as! UIFont
        
        XCTAssert(font.isBold() == true)
    }
    
    func test_fromHTML_returnTheRightString() {
        
        self.label.font = UIFont(name: "Arial", size: 14)
        
        self.label.html = "texto <b>importante</b>"
        
		let font = self.label.attributedText?.attribute(named:NSAttributedStringKey.font.rawValue, forText: "importante") as! UIFont
        
        XCTAssert(font.isBold() == true)
    }
    
    func test_fromHTML_preservesLabelColor() {

        self.label.textColor = UIColor.red
        self.label.html = "texto <b>importante</b>"
        
		let color = self.label.attributedText?.attribute(named:NSAttributedStringKey.foregroundColor.rawValue, forText: "importante") as! UIColor
        
        XCTAssert(equalColors(color, c2: UIColor.red))
    }
}

// MARK: Helpers

extension NSAttributedString {
    
    func attribute(named name: String, forText text: String) -> AnyObject? {
        
        let string = self.string
        let substringRangeOptional = string.range(of: text)
        
        guard let substringRange = substringRangeOptional else { return nil }
        
        let start = string.characters.distance(from: string.startIndex, to: substringRange.lowerBound)
        let length = string.characters.distance(from: substringRange.lowerBound, to: substringRange.upperBound)
        
        var attributedRange = NSMakeRange(0, length-1)
		let attribute = self.attribute(NSAttributedStringKey(rawValue: name), at: start, effectiveRange: &attributedRange)
        return attribute as AnyObject?
    }
}

extension UIFont {
    
    func isBold() -> Bool {
        
        return ((self.fontDescriptor.symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.traitBold).rawValue) != 0)
    }
}

private func equalColors (_ c1:UIColor, c2:UIColor) -> Bool{
    
    var red:CGFloat = 0
    var green:CGFloat  = 0
    var blue:CGFloat = 0
    var alpha:CGFloat  = 0
    c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    var red2:CGFloat = 0
    var green2:CGFloat  = 0
    var blue2:CGFloat = 0
    var alpha2:CGFloat  = 0
    c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
    
    return (Int(green*255) == Int(green2*255))
    
}
