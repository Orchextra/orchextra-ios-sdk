//
//  OptionsPickerComponent.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 18/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

protocol POptionsPickerComponent {
    func formFieldDidFinish()
}

class OptionsPickerComponent: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegateOption: POptionsPickerComponent?
    var styles: FormFieldStyleModel?
    var textAcceptButton: String?
    var items: [FormFieldOptionsModel] = [] {
        didSet {
            self.picker.reloadAllComponents()
            self.textField?.text = self.items[0].textOption
        }
    }
    
    var selectedIndex: Int? {
        get {
            return !(self.textField!.text?.isEmpty ?? true) ? self.picker.selectedRow(inComponent: 0) : 0
        }
        
        set {
            self.picker.selectRow(newValue ?? 0, inComponent: 0, animated: false)
            if !self.items.isEmpty {
                let selectedRow = self.picker.selectedRow(inComponent: 0)
                self.textField?.text = self.items[selectedRow].textOption
            }
        }
    }
    
    var textField: UITextField?
    
    // Private properties
    fileprivate let picker = UIPickerView()
    
    // MARK: Public Method
    
    func initTextField(_ textField: UITextField) {
        self.textField = textField
        self.setupPicker()
        self.setupDoneToolbar()
    }
    
    func populateData(_ value: Any?) {
        guard let key = value as? String else {
            return
        }
        
        var index = 0
        for item in self.items {
            if item.idOption == key {
                break
            }
            index += 1
        }
        self.selectedIndex = index
    }
    
    // MARK: DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.items[row].textOption
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard !self.items.isEmpty else { return }
        self.textField?.text = self.items[row].textOption
    }
    
    // MARK: - Private Helpers

    fileprivate func setupPicker() {
        self.picker.dataSource = self
        self.picker.delegate = self
        self.textField!.inputView = self.picker
    }
    
    fileprivate func setupDoneToolbar() {
        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = self.styles?.containerAcceptColorPicker
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title:self.textAcceptButton, style: UIBarButtonItemStyle.done, target: self, action: #selector(onDoneTap))
        doneButton.tintColor = self.styles?.acceptColorPicker

        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.textField!.inputAccessoryView = toolBar
        self.picker.backgroundColor = self.styles?.backgroundPickerColorPicker
    }
    
    @objc fileprivate func onDoneTap() {
        if !self.items.isEmpty {
            let selectedRow = self.picker.selectedRow(inComponent: 0)
            self.textField?.text = self.items[selectedRow].textOption
            self.delegateOption?.formFieldDidFinish()
        }
        self.textField?.endEditing(true)
    }
}
