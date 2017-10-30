//
//  BooleanFormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 27/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary


protocol PBooleanFormField {
    func userDidTapLink(_ key: String)
}

class BooleanFormField: FormField {

    @IBOutlet var buttonAccept: UIButton!
    @IBOutlet var titleLabel: FRHyperLabel!
    @IBOutlet var mandotoryImage: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet weak var heightErrorLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthMandatoryImageConstraint: NSLayoutConstraint!
    
    //-- Local var --
    var checkBoxOn: UIImage?
    var checkBoxOff: UIImage?
    
    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.awakeFromNib(frame, classField: type(of: self))
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: VALIDATE
    
    override func validate() -> Bool {
        let status = super.validate()
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
    
    // MARK: Public Method
    
    override func insertData() {
        super.insertData()
        self.loadCustomStyleField(self.formFieldM!)
        self.loadData(self.formFieldM!)
        self.loadMandatory(self.formFieldM!.mandatory)
    }
        
    override func loadError(error: Any) {
        guard let text = error as? String else { return }
        self.errorLabel.text = text
        self.showError()
    }
    
    // MARK: GIGFormField (Override)
    
    override internal var fieldValue: Any? {
        get {
            return self.buttonAccept.isSelected as Any?
        }
        set {
            guard let boolValue = newValue as? Bool else {
                self.chooseImage()
                return
            }
            self.buttonAccept.isSelected = boolValue
            self.chooseImage()
        }
    }
    
    // MARK: Private Method
    
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
    
    fileprivate func initializeView() {
        self.titleLabel.numberOfLines = 0
        self.errorLabel.numberOfLines = 0
        self.mandotoryImage.image = UIImage(named: "mandatoryIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.checkBoxOn = UIImage(named: "chackBoxOn", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.checkBoxOff = UIImage(named: "checkBox", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.buttonAccept.setBackgroundImage(self.checkBoxOff, for: UIControlState())
    }
    
    // MARK: Load data field
    
    fileprivate func loadData(_ formFieldM: FormFieldModel) {
        self.titleLabel.text = formFieldM.label
        self.errorLabel.text = formFieldM.textsError.textError
        if formFieldM.value != nil && (formFieldM.value as? Bool)! {
            self.changeState()
        }
        
        self.buttonAccept.isEnabled = formFieldM.isEditing
        
        //-- Text parse view --
        guard let label = formFieldM.label else { LogInfo("BooleanFormField label is nil"); return }
        if self.existLink(label) {
            let getLinks = self.getListLinks(label)
            
            //Step 1: Styles
            if let styleField = formFieldM.style,
                let titleColor =  styleField.titleColor {
    
                let attributes = [NSAttributedStringKey.foregroundColor: titleColor,
                                  NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
                self.titleLabel.attributedText = NSAttributedString(string: getLinks.1, attributes: attributes)
                
                self.titleLabel.linkAttributeHighlight = [
                    NSAttributedStringKey.foregroundColor: UIColor.blue,
                    NSAttributedStringKey.underlineStyle: 1
                ]
                
                self.titleLabel.linkAttributeDefault = [
                    NSAttributedStringKey.foregroundColor: titleColor,
                    NSAttributedStringKey.underlineStyle: 1
                ]
                
                self.titleLabel.font = styleField.fontTitle
            } else {
                self.titleLabel.font = UIFont.systemFont(ofSize: 17)
                let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                  NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
                self.titleLabel.attributedText = NSAttributedString(string: getLinks.1, attributes: attributes)
            }
            
            //Step 2: Define a selection handler block
            let handler = {
                (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                if let key = substring {
                    self.formFieldOutput?.userDidTapLink(key)
                }                
            }
            
            //Step 3: Add link substrings
            self.titleLabel.setLinksForSubstrings(getLinks.0, withLinkHandler: handler)
        }
    }
    
    fileprivate func loadMandatory(_ isMandatory: Bool) {
        if isMandatory {
            self.widthMandatoryImageConstraint.constant = 30
        } else {
            self.widthMandatoryImageConstraint.constant = 0
        }
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
            }
            if styleField!.fontError != nil {
                self.errorLabel.font = styleField?.fontError
            }
            if styleField!.align != nil {
                self.titleLabel.textAlignment = styleField!.align!
            }
            if styleField!.checkBoxOn != nil {
                self.checkBoxOn = styleField!.checkBoxOn!
                self.buttonAccept.setBackgroundImage(self.checkBoxOn, for: UIControlState.selected)
            }
            if styleField!.checkBoxOff != nil {
                self.checkBoxOff = styleField!.checkBoxOff!
                self.buttonAccept.setBackgroundImage(self.checkBoxOff, for: UIControlState())
            }
        }
    }
    
    fileprivate func changeState() {
        if self.buttonAccept.isSelected {
            self.buttonAccept.setBackgroundImage(self.checkBoxOff, for: UIControlState())
        } else {
            self.buttonAccept.setBackgroundImage(self.checkBoxOn, for: UIControlState())
            self.buttonAccept.setBackgroundImage(self.checkBoxOn, for: UIControlState.selected)
        }
        self.buttonAccept.isSelected = !self.buttonAccept.isSelected
    }
    
    fileprivate func chooseImage() {
        if self.buttonAccept.isSelected {
            self.buttonAccept.setBackgroundImage(self.checkBoxOn, for: UIControlState.selected)
        } else {
            self.buttonAccept.setBackgroundImage(self.checkBoxOff, for: UIControlState())
        }
    }
    
    // MARK: Parse
    
    fileprivate func existLink(_ text: String) -> Bool {
        // TODO EDU otra opcion // return text.characters.index(of: "{") != nil
        if text.characters.index(of: "{") != nil {
            return true
        }
        return false
    }
    
    fileprivate func getListLinks(_ text: String) -> ([String], String) {
        let newStringKey = text.replacingOccurrences(of: "{* ", with: "{* #", options: .literal, range: nil)
        let firstPart = newStringKey.components(separatedBy: "{* ")
        let localizedStringPieces = self.separeteString(listPart: firstPart)
        
        var listLink = [String]()
        var allWords = ""
        for word in localizedStringPieces {
            if word.hasPrefix("#") {
                let link = word.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
                listLink.append(link)
                allWords += link
            } else {
                allWords += word
            }
        }
        
        return (listLink, allWords)
    }
    
    fileprivate func separeteString(listPart: [String]) -> [String] {
        var auxList = [String]()
        for text in listPart {
            let findPart = text.components(separatedBy: " *}")
            auxList += findPart
        }
        return auxList
    }
    
    
    // MARK: Actions
    
    @IBAction func actionButtonAccept(_ sender: AnyObject) {
        self.changeState()
    }
    
    func labelAction(grTap: UITapGestureRecognizer) {
        self.formFieldOutput?.userDidTapLink((self.formFieldM?.key)!)
    }
    
    // MARK: UIResponser (Overrride)
    override var canBecomeFirstResponder: Bool {
        return false
    }
}
