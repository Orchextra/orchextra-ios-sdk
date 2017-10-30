//
//  FormFieldStyleModel.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 29/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

enum TypeStyleCell: String {
    case defaultStyle = "default"
    case lineStyle = "line"
}

class FormFieldStyleModel: NSObject {
    
    var bundle: Bundle
    
    //-- Styles --
    var mandatoryIcon: UIImage?
    var backgroundColorField: UIColor?
    var titleColor: UIColor?
    var errorColor: UIColor?
    var acceptColorPicker: UIColor?
    var containerAcceptColorPicker: UIColor?
    var backgroundPickerColorPicker: UIColor?
    var fontTitle: UIFont?
    var fontError: UIFont?
    var align: NSTextAlignment?
    var checkBoxOn: UIImage?
    var checkBoxOff: UIImage?
    var styleCell: TypeStyleCell?
    
    init(bundle: Bundle) {
        self.bundle = bundle
        super.init()
    }
    
    func parseDictionary(_ json: [AnyHashable: Any]) {
        //== PREPARE DATA ==
        let sizeTitle = json["sizeTitle"] as? CGFloat
        let sizeError = json["sizeError"] as? CGFloat        

        //== INSERT DATA ==
        if let styleCustom = json["styleCell"] as? String {
            self.styleCell = TypeStyleCell(rawValue: styleCustom)
        }
        if let backgroundColorField = json["backgroundColorField"] as? String {
            self.backgroundColorField = UIColor(fromHexString: backgroundColorField)
        }
        if let titleColor = json["titleColor"] as? String {
            self.titleColor = UIColor(fromHexString: titleColor)
        }
        if let errorColor = json["errorColor"] as? String {
            self.errorColor = UIColor(fromHexString: errorColor)
        }
        if let acceptColorPicker = json["acceptColorPicker"] as? String {
            self.acceptColorPicker = UIColor(fromHexString: acceptColorPicker)
        } else {
            self.acceptColorPicker = UIColor.black
        }
        if let containerAcceptColorPicker = json["containerAcceptColorPicker"] as? String {
            self.containerAcceptColorPicker = UIColor(fromHexString: containerAcceptColorPicker)
        } else {
            self.containerAcceptColorPicker = UIColor.gray
        }
        if let backgroundPickerColorPicker = json["backgroundPickerColorPicker"] as? String {
            self.backgroundPickerColorPicker = UIColor(fromHexString: backgroundPickerColorPicker)
        } else {
            self.containerAcceptColorPicker = UIColor.gray
        }
        if let font = json["font"] as? String {
            if let sizeTitle = sizeTitle {
                self.fontTitle = UIFont (name: font, size: sizeTitle)
            } else {
                self.fontTitle = UIFont (name: font, size: 17)
            }
            if let sizeError = sizeError {
                self.fontError = UIFont (name: font, size: sizeError)
            } else {
                self.fontError = UIFont (name: font, size: 15)
            }
        } else {
            if let sizeTitle = sizeTitle {
                self.fontTitle = UIFont.systemFont(ofSize: sizeTitle)
            }
            if let sizeError = sizeError {
                self.fontError = UIFont.systemFont(ofSize: sizeError)
            }
        }
        if let align = json["align"] as? String {
            switch align {
                case "alignCenter": self.align = NSTextAlignment.center
                case "alignRight": self.align = NSTextAlignment.right
                case "alignLeft": self.align = NSTextAlignment.left
                default: self.align = NSTextAlignment.center
            }
        }
        if let mandatoryImage = json["mandatoryIcon"] as? String {
            self.mandatoryIcon = UIImage(named: mandatoryImage, in: self.bundle, compatibleWith: nil)
        }
        if let checkBox = json["checkBox"] as? [String:String] {
            if let checkOn = checkBox["checkBoxOn"] {
                self.checkBoxOn = UIImage(named: checkOn, in: self.bundle, compatibleWith: nil)
            }
            if let checkOff = checkBox["checkBoxOff"] {
                self.checkBoxOff = UIImage(named: checkOff, in: self.bundle, compatibleWith: nil)
            }
        }
    }
}
