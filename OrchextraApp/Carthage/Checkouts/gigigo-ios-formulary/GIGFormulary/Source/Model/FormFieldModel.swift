//
//  FormFieldModel.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 29/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class FormFieldModel: NSObject {
    
    var bundle: Bundle
    
    //-- Mandatory --
    var key: String?
    var type: String?
    var label: String?
    
    //-- Optional --    
    var placeHolder: String?
    var keyboard: String?
    var options: [FormFieldOptionsModel]?
    var style: FormFieldStyleModel?
    var validator: String?
    var keyBoard: String?
    var textAcceptButton: String?
    var value: Any?
    var isPassword = false
    var textsError = TextsError()
    var isEditing = true
    var isHidden = false
    //-- Validate --
    var minLengthValue: Int?
    var maxLengthValue: Int?
    var minAge: Int?
    var mandatory = false
    var custom: String?
    var isLink = false
    var compare = false
    var itemCompare: [String]?
    
    init(bundle: Bundle) {
        self.bundle = bundle
        super.init()
    }
    
    // MARK: Public Method
    
    func parseDictionary(_ json: [AnyHashable: Any]) throws {
        //== PREPARE DATA ==
        
        //-- Mandatory --
        guard let type = json["type"] as? String, type.characters.count > 0 else {
            LogWarn("type Not Found")
            throw ThrowError.mandatoryElementNotFound
        }

        guard let key = json["key"] as? String, key.characters.count > 0 else {
            LogWarn("key Not Found")
            throw ThrowError.mandatoryElementNotFound
        }
    
        
        //== INSERT DATA ==
        //-- Mandatory--
        self.type = type
        self.key = key
        
        //-- Optional--
        
        if let label = json["label"] as? String {
            self.label = NSLocalizedString(label, comment: "")
        }
        if let textError = json["textError"] as? String {
            self.textsError.textError = NSLocalizedString(textError, comment: "")
        } else {
            self.textsError.textError = NSLocalizedString("error_generic_field", tableName: nil, bundle: Bundle(for: Swift.type(of: self)), value: "", comment: "error_generic_field")
        }
        if let textErrorCompare = json["textErrorCompare"] as? String {
            self.textsError.textErrorCompare = NSLocalizedString(textErrorCompare, comment: "")
        } else {
            self.textsError.textErrorCompare = NSLocalizedString("error_generic_compare_field", tableName: nil, bundle: Bundle(for: Swift.type(of: self)), value: "", comment: "error_generic_compare_field")
        }
        if let placeHolder = json["placeHolder"] as? String {
            self.placeHolder = NSLocalizedString(placeHolder, comment: "")
        }

        if json["listOptions"] != nil {
            guard let listOptions = json["listOptions"] as? [[AnyHashable: Any]] else {
                LogWarn(" listOptions incorrect type")
                throw ThrowError.mandatoryElementIncorrectType
            }
            if listOptions.count == 0 {
                LogWarn("listOptions empty")
                throw ThrowError.mandatoryElementEmpty
            }
            do {
                self.options = try FormFieldOptionsModel.parseListOptionsJson(listOptions)
            } catch {
                LogWarn("options Not Found")
                throw ThrowError.mandatoryElementNotFound
            }
        }
        if let styleM = json["style"] as? [AnyHashable: Any] {
            self.style = FormFieldStyleModel(bundle: self.bundle)
            self.style?.parseDictionary(styleM)
        }
        if let validator = json["validator"] as? String {
            self.validator = validator
        }
        if let keyBoard = json["keyboard"] as? String {
            self.keyBoard = keyBoard
        }
        if let textAccept  = json["textAcceptButton"] as? String {
            self.textAcceptButton = NSLocalizedString(textAccept, tableName: nil, bundle: self.bundle, value: "", comment: "")
        } else {
            self.textAcceptButton = NSLocalizedString("gig_form_accept_button_picker", tableName: nil, bundle: Bundle(for: Swift.type(of: self)), value: "", comment: "gig_form_accept_button_picker")
        }
        if let value = json["value"] {
            self.value = value
        }
        if let isPassword = json["isPassword"] as? Bool {
            self.isPassword = isPassword
        }
        if let isLink = json["isLink"] as? Bool {
            self.isLink = isLink
        }
        if let isEditing = json["isEditing"] as? Bool {
            self.isEditing = isEditing
        }
        if let isHidden = json["isHidden"] as? Bool {
            self.isHidden = isHidden
        }
        
        //-- Validate --
        if let maxLength = json["maxLength"] as? Int {
            self.maxLengthValue = maxLength
        }
        if let minLength = json["minLength"] as? Int {
            self.minLengthValue = minLength
        }
        if let minAge = json["minAge"] as? Int {
            self.minAge = minAge
        }
        if let mandatory = json["mandatory"] as? Bool {
            self.mandatory = mandatory
        }
        if let custom = json["customValidator"] as? String {
            self.custom = custom
        }
        if let compare = json["compare"] as? Bool {
            self.compare = compare
        }
        if let itemCompare = json["itemsCompare"] as? [String] {
            self.itemCompare = itemCompare
        }
        if let textErrorValidate = json["textErrorValidate"] as? String {
            self.textsError.textErrorValidate = textErrorValidate
        } else {
            self.textsError.textErrorValidate = self.textsError.textError
        }
    }
}
