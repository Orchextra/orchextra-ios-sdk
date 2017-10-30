//
//  FormBuilder.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class FormBuilderFields: NSObject {
    
    //-- Controller --
    var formController: FormController
        
    //-- Types --
    var listTypeFields = [TypeField: FormField.Type]()
    var keyboardTypes = [TypeKeyBoard: UIKeyboardType]()
    var validatorsType = [TypeValidator: Validator.Type]()

    //-- Var --
    var bundle: Bundle
    
    //-- INIT --
    
    init(formController: FormController, bundle: Bundle) {
        self.formController = formController
        self.bundle = bundle
        
        super.init()
        
        self.initializeTypes()
    }
    
    
    // MARK: Public Method
    
    func fieldsFromJSONFile(_ file: String) -> [FormField] {
        var listFormField = [FormField]()
        let jsonRecover = Bundle.main.loadJSONFile(file, rootNode: "fields")
        if jsonRecover != nil {
            guard let listFormDic = jsonRecover as? [[AnyHashable: Any]] else { LogWarn("Parse error [[AnyHashable: Any]]"); return [] }
            for fieldDic in listFormDic {
                listFormField.append(self.createField(fieldDic))
            }
        } else {
            LogWarn("json fields Not Found or Bad format")
        }
        
        return listFormField
    }
    
    func fieldsFromDictionary(_ listItems: [[AnyHashable: Any]]) -> [FormField] {
        var listFormField = [FormField]()
        for fieldDic in listItems {
            listFormField.append(self.createField(fieldDic))
        }
        return listFormField
    }
    
    
    // MARK: Private Method
    
    fileprivate func initializeTypes() {
        self.listTypeFields = [.textFormField: TextFormField.self,
                               .pickerFormField: PickerFormField.self,
                               .datePickerFormField: PickerFormField.self,
                               .boolFormField: BooleanFormField.self,
                               .indexFormField: IndexFormField.self]
        
        self.keyboardTypes  = [.keyboardText: .default,
                              .keyboardEmail: .emailAddress,
                              .keyboardNumber: .numbersAndPunctuation,
                              .keyboardNumberPad: .numberPad]

        self.validatorsType = [.validatorText: StringValidator.self,
                               .validatorEmail: MailValidator.self,
                               .validatorLength: LengthValidator.self,
                               .validatorNumeric: NumericValidator.self,
                               .validatorPostalCode: PostalCodeValidator.self,
                               .validatorPhone: PhoneValidator.self,
                               .validatorBool: BoolValidator.self,
                               .validatorDniNie: DNINIEValidator.self,
                               .validatorAge: AgeValidator.self,
                               .validatorCustom: CustomValidator.self]
    }
    
    fileprivate func createField(_ fieldDic: [AnyHashable: Any]) -> FormField {
        do {
            let formFieldM = FormFieldModel(bundle: self.bundle)
            try formFieldM.parseDictionary(fieldDic)
            
            guard let typeFieldFound = TypeField(rawValue: formFieldM.type!) else {
                LogWarn("typeFieldFound not found")
                return FormField()
            }
            let typeField = self.listTypeFields[typeFieldFound]
            let field = typeField!.init()
            field.formFieldM = formFieldM
            field.formFieldOutput = self.formController
            field.validator = self.validatorToField(formFieldM)
            field.keyBoard = self.keyboardToField(formFieldM)
            field.insertData()
            return field
        } catch {
            let field = FormField()
            return field
        }
    }
    
    fileprivate func validatorToField(_ formFieldM: FormFieldModel) -> Validator? {
        guard
            let validate = formFieldM.validator,
            let typeValidate = TypeValidator(rawValue: validate)
            else {
                return Validator(mandatory: formFieldM.mandatory)
        }
        
        let typeValidator = self.validatorsType[typeValidate]
        let validator: Validator
        if let custom = formFieldM.custom {
            validator = typeValidator!.init(mandatory: formFieldM.mandatory, custom: custom)
        } else {
            validator = typeValidator!.init(mandatory: formFieldM.mandatory)
        }
        validator.minLength = formFieldM.minLengthValue
        validator.maxLength = formFieldM.maxLengthValue
        validator.minAge = formFieldM.minAge
        return validator
    }
    
    fileprivate func keyboardToField(_ formFieldM: FormFieldModel) -> UIKeyboardType? {
        if formFieldM.keyBoard != nil {
            return self.keyboardTypes[TypeKeyBoard(rawValue: formFieldM.keyBoard!)!]
        } else {
            return UIKeyboardType.default
        }
    }
}
