//
//  PickerFormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class PickerFormField: FormField, POptionsPickerComponent, PDatePickerComponent {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textTextField: UITextField!
    @IBOutlet var mandotoryImage: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet weak var heightErrorLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthMandatoryImageConstraint: NSLayoutConstraint!
    
    var pickerOptions: OptionsPickerComponent?
    var pickerDate: DatePickerComponent?
    
    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.awakeFromNib(frame, classField: type(of: self))
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: GIGFormField (Override)
    
    override internal var fieldValue: Any? {
        get {
            if self.formFieldM!.type == TypeField.pickerFormField.rawValue {
                return (self.formFieldM!.options![self.pickerOptions!.selectedIndex!]).idOption
            } else {
                if self.pickerDate!.dateSelected != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    return dateFormatter.string(from: self.pickerDate!.dateSelected!)
                }
                return ""
            }
        }
        set {
            if self.formFieldM!.type == TypeField.pickerFormField.rawValue {
                let optionFound = self.formFieldM!.options?.filter({ element -> Bool in
                     return element.idOption == newValue as? String
                })
                
                var pos = 0
                if let option = optionFound {
                    if  option.count > 0 {
                       pos = self.formFieldM!.options!.index(of: option[0])!
                    }
                }
                self.pickerOptions?.selectedIndex = pos
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                guard let valueString = newValue! as? String else { return LogWarn("Value isnt String") }
                self.pickerDate?.dateSelected = dateFormatter.date(from: valueString)
            }
        }
    }
    
    // MARK: Private Method
    
    fileprivate func initializeView() {
        self.titleLabel.numberOfLines = 0
        self.errorLabel.numberOfLines = 0
        self.mandotoryImage.image = UIImage(named: "mandatoryIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    fileprivate func showError() {
        UIView.animate(withDuration: 0.5, animations: {
            self.errorLabel.sizeToFit()
            self.heightErrorLabelConstraint.constant =  self.errorLabel.frame.height
            self.viewPpal?.layoutIfNeeded()
        }) 
    }
    
    fileprivate func hideError() {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightErrorLabelConstraint.constant = 0
            self.viewPpal?.layoutIfNeeded()
        }) 
    }
    
    // MARK: Overrride Method
    
    override func insertData() {
        super.insertData()
        if self.formFieldM!.type == TypeField.pickerFormField.rawValue {
            self.pickerOptions = OptionsPickerComponent()
            self.pickerOptions?.styles = self.formFieldM?.style
            self.pickerOptions?.textAcceptButton = self.formFieldM?.textAcceptButton
            self.pickerOptions!.initTextField(self.textTextField)
            self.pickerOptions!.items = self.formFieldM!.options!
            self.pickerOptions?.populateData(self.formFieldM!.value)
            self.pickerOptions?.delegateOption = self
        } else {
            self.pickerDate = DatePickerComponent()
            self.pickerDate?.styles = self.formFieldM?.style
            self.pickerDate?.textAcceptButton = self.formFieldM?.textAcceptButton
            self.pickerDate!.initTextField(self.textTextField)
            self.pickerDate?.populateData(self.formFieldM?.value)
            self.pickerDate?.delegateDate = self
        }
        self.loadData(self.formFieldM!)
        self.loadMandatory(self.formFieldM!.mandatory)
        self.loadCustomStyleField(self.formFieldM!)
        self.loadKeyboard(self.formFieldM!)
    }
        
    override func loadError(error: Any) {
        guard let text = error as? String else { return }
        self.errorLabel.text = text
        self.showError()
    }
    
    override func validate() -> Bool {
        var status = true
        if self.formFieldM!.type == TypeField.pickerFormField.rawValue {
            self.validator = OptionValidator(mandatory: self.formFieldM!.mandatory)
            status = self.validator!.validate(self.pickerOptions?.selectedIndex)
        } else {
            status = self.validator!.validate(self.pickerDate?.dateSelected)
        }
        
        if !status {
            if self.isErrorGeneric() {
                self.errorLabel.text = self.formFieldM?.textsError.textError
            } else {
                self.errorLabel.text = self.formFieldM?.textsError.textErrorValidate
            }
            self.showError()
        } else {
            self.hideError()
        }
        
        return status
    }
    
    // MARK: POptionsPickerComponent
    
    func formFieldDidFinish() {
        self.formFieldOutput?.formFieldDidFinish(self)
    }
    
    // MARK: PDatePickerComponent
    
    func formFieldDidFinishDate() {
        self.formFieldOutput?.formFieldDidFinish(self)
    }
    
    // MARK: Load data field
    
    fileprivate func loadData(_ formFieldM: FormFieldModel) {
        self.titleLabel.text = formFieldM.label
        self.textTextField.placeholder = formFieldM.placeHolder
        self.errorLabel.text = formFieldM.textsError.textError
        self.textTextField.isEnabled = formFieldM.isEditing
    }
    
    fileprivate func loadMandatory(_ isMandatory: Bool) {
        if isMandatory {
            self.widthMandatoryImageConstraint.constant = 30
        } else {
            self.widthMandatoryImageConstraint.constant = 0
        }
    }
    
    fileprivate func loadKeyboard(_ formFieldM: FormFieldModel) {
        self.textTextField.keyboardType = self.keyBoard!
    }
    
    fileprivate func loadCustomStyleField(_ formFieldM: FormFieldModel) {
        let styleField = formFieldM.style
        if styleField != nil {
            if styleField!.mandatoryIcon != nil {
                self.mandotoryImage.image = styleField?.mandatoryIcon
            }
            if styleField!.backgroundColorField != nil {
                self.viewContainer.backgroundColor = styleField!.backgroundColorField!
            }
            if styleField!.titleColor != nil {
                self.titleLabel.textColor = styleField!.titleColor!
            }
            if styleField!.errorColor != nil {
                self.errorLabel.textColor = styleField!.errorColor!
            }
            if styleField!.fontTitle != nil {
                self.titleLabel.font = styleField?.fontTitle
                self.textTextField.font = styleField?.fontTitle
            }
            if styleField!.fontError != nil {
                self.errorLabel.font = styleField?.fontError
            }
            if styleField!.align != nil {
                self.titleLabel.textAlignment = styleField!.align!
            }
            if let styleCell = styleField?.styleCell {
                switch styleCell {
                case .defaultStyle:
                    // TODO nothing
                    break
                case .lineStyle:
                    self.customizeCell()
                }
            }
        }
    }
    
    fileprivate func customizeCell() {
        self.textTextField.borderStyle = UITextBorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.textTextField.frame.size.height - width, width:  UIScreen.main.bounds.width, height: self.textTextField.frame.size.height)
        
        border.borderWidth = width
        self.textTextField.layer.addSublayer(border)
        self.textTextField.layer.masksToBounds = true
    }
        
    // MARK: UIResponser (Overrride)
    override var canBecomeFirstResponder: Bool {
        return self.textTextField.canBecomeFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textTextField.becomeFirstResponder()
    }
    override func resignFirstResponder() -> Bool {
        return self.textTextField.resignFirstResponder()
    }
}
