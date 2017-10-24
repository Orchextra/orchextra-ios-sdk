//
//  UserVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class UserVC: BaseVC, UserUI {
    
    // MARK: - Attributtes
    var presenter: UserPresenter?

    // MARK: - IBOutlets
    
    // TODO: Use a textfield or a text view to input the information? (Textview needed to support multiline design)
    @IBOutlet weak var crmIdTextView: UITextView!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var businessUnitTextfield: UITextField!
    @IBOutlet weak var customFieldTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        self.title = "User"
        self.hideKeyboardWhenTappedAround()
    }
}

extension UserVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "UserVC"
}

extension UserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tagsTextField {
            if let tags = textField.text {
                self.presenter?.userDidSet(tags: tags)
            }
        } else if textField == self.businessUnitTextfield {
            if let businessUnits = textField.text {
                self.presenter?.userDidSet(businessUnits: businessUnits)
            }
        } else if textField == self.customFieldTextfield {
            if let customFields = textField.text {
                self.presenter?.userDidSet(customFields: customFields)
            }
        } else if textField == self.nameTextfield {
            if let name = textField.text {
                self.presenter?.userDidSet(name: name)
            }
        } else if textField == self.surnameTextfield {
            if let surname = textField.text {
                self.presenter?.userDidSet(surname: surname)
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}

extension UserVC: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == crmIdTextView {
            self.presenter?.userDidSet(crmId: textView.text)
        }
        textView.resignFirstResponder()
        return true
    }
}
