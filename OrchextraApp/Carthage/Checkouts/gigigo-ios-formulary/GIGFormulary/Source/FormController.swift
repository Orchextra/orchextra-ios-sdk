//
//  FormController.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

protocol PFormController {
    func recoverFormModel(_ formValues: [AnyHashable: Any])
    func userDidTapLink(_ key: String)
    func fieldFocus(frame: CGRect, key: String?)
    func invalidForm()
}

class FormController: NSObject, PFormField, PFormBuilderViews {
    // Public Var
    var formControllerOutput: PFormController?
    
    // CLASS
    var formViews: FormBuilderViews?
    
    // VAR
    var formFields = [FormField]()
    var formValues = [AnyHashable: Any]()
    var bundle = Bundle(for: Formulary.self)
    
    // INIT
    
    init(viewContainerFormulary: UIView, bundle: Bundle?) {
        super.init()
        self.formViews = FormBuilderViews(
            viewContainerFormulary: viewContainerFormulary,
            formController: self
        )
        
        self.loadBundle(bundle)
    }
    
    init(button: UIButton, bundle: Bundle?) {
        super.init()
        self.formViews = FormBuilderViews(
            button: button,
            formController: self
        )
        
        self.loadBundle(bundle)
    }
    
    // MARK: Public Method
    
    func loadFieldsFromJSONFile(_ jsonFile: String) {
        let builder = FormBuilderFields(formController: self, bundle: self.bundle)
        self.formFields = builder.fieldsFromJSONFile(jsonFile)        
        self.formViews!.updateFormularyContent(self.formFields)
    }
    
    func loadFieldsFromJSONDictionary(_ listItems: [[AnyHashable: Any]]) {
        let builder = FormBuilderFields(formController: self, bundle: self.bundle)
        self.formFields = builder.fieldsFromDictionary(listItems)
        self.formViews!.updateFormularyContent(self.formFields)
    }
    
    func populateData(_ values: [AnyHashable: Any]) {
        var _ = values.map {key, value -> [AnyHashable: Any] in
            var _ = self.formFields.map { formField -> FormField in
                if formField.formFieldM?.key == key {
                    formField.fieldValue = value
                    self.formValues[key] = value
                }
                return formField
            }
            return [key: value]
        }
    }
    
    func loadError(_ values: [AnyHashable: Any]) {
        var search = true
        for field in self.formFields {
            _ = values.filter({ (key, value) -> Bool in
                if key == field.formFieldM?.key {
                    field.loadError(error: value)
                    
                    //-- Go to position if first found --
                    self.moveToPositionError(search, field)
                    search = false
                }
                return true
            })
        }
    }
    
    func recoverView() -> UIView {
        return self.formViews!.recoverViewContainer()
    }
    
    func clearFormulary() {
        self.formViews?.clearFormulary()
    }
    
    // MARK: Private Method

    fileprivate func loadBundle(_ bundle: Bundle?) {
        if let bundleForm = bundle {
            self.bundle = bundleForm
        }
    }
    
    fileprivate func nextFieldTo(_ field: FormField) -> FormField? {
        let nextFieldPos =  self.formFields.index(of: field)!+1
        if nextFieldPos < self.formFields.count {
            let nextField = self.formFields[nextFieldPos]
            if nextField.formFieldM?.type == TypeField.indexFormField.rawValue || (nextField.formFieldM?.isHidden)! {
                return self.nextFieldTo(nextField)
            }
            return nextField
        } else {
            return nil
        }
    }
    
    fileprivate func validateFields() -> Bool {
        var isValid = true
        for field in self.formFields {
            guard let formFieldM = field.formFieldM else {
                return false
            }

            if !field.validate() {
                self.moveToPositionError(isValid, field)
                isValid = false
            } else {
                if formFieldM.compare {
                    guard let itemsCompare = formFieldM.itemCompare else {
                        return false
                    }
                    
                    let listValues = self.searchValueItemToCompare(itemsCompare)
  
                    if field.validator!.validateCompare(listValues) {
                        isValid = false
                        field.validateCompare()
                    }
                }
            }
            
            if formFieldM.type != TypeField.indexFormField.rawValue {
                if let key = formFieldM.key {
                    if let valueString = field.fieldValue as? String {
                        let value = valueString.trimmingCharacters(in: .whitespaces)
                        self.formValues["\(key)"] = value as Any?
                    } else {
                        self.formValues["\(key)"] = (field.fieldValue != nil) ? field.fieldValue as Any : "" as Any
                    }
                } else {
                    LogWarn("validateFields -> formFieldM.key is Nil")
                    return false
                }
            }
            
            if formFieldM.type != TypeField.indexFormField.rawValue {
                if let key = formFieldM.key {
                    if let valueString = field.fieldValue as? String {
                        let value = valueString.trimmingCharacters(in: .whitespaces)
                        self.formValues["\(key)"] = value as Any?
                    } else {
                        self.formValues["\(key)"] = (field.fieldValue != nil) ? field.fieldValue as Any : "" as Any
                    }
                } else {
                    LogWarn("validateFields -> formFieldM.key is Nil")
                    return false
                }
            }
        }
        return isValid
    }
    
    fileprivate func moveToPositionError(_ isValid: Bool, _ field: FormField) {
        if isValid {
            self.formViews?.scrollRectToVisible(field)
        } else {
            self.formControllerOutput?.invalidForm()
        }
    }
    
    fileprivate func searchValueItemToCompare(_ itemsCompare: [String]) -> [String] {
        let listValues = itemsCompare.map({ (key: String) -> String in
            let itemFound: [FormField] = self.formFields.filter({ formFieldSearch -> Bool in
                return formFieldSearch.formFieldM?.key == key
            })
            
            if itemFound.count > 0 {
                if itemFound[0].fieldValue != nil {
                    guard let fieldString = itemFound[0].fieldValue as? String else { LogWarn("Parse value to String error"); return "" }
                    return fieldString
                } else {
                    return ""
                }
            }
            return ""
        })
        
        return listValues
    }
 
    // MARK: PFormBuilderViews
    
    func sendButtonAction() {
        if self.validateFields() {
            self.formControllerOutput?.recoverFormModel(self.formValues)
        }
    }
    
    // MARK: PTextFormField
    func scrollRectToVisible(_ field: FormField) {
        self.formViews?.scrollRectToVisible(field)
        self.formControllerOutput?.fieldFocus(frame: field.frame, key: field.formFieldM?.key)
    }
    
    func formFieldDidFinish(_ field: FormField) {
        let nextField = self.nextFieldTo(field)
        self.formViews?.changeFocusField(nextField)
        
        if nextField == nil {
            self.sendButtonAction()
        }
    }
    
    func userDidTapLink(_ key: String) {
        self.formControllerOutput?.userDidTapLink(key)
    }
}
