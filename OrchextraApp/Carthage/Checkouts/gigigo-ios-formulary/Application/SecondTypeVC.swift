//
//  SecondTypeVC.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 21/9/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGFormulary
import GIGLibrary

class SecondTypeVC: UIViewController, PFormulary {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    let formulary = Formulary.shared
    
    func prepareField() -> [Any] {
        let emailField: [Any] = [
            [
                "key": "textoKey2",
                "type": "text",
                "label": "texto2",
                "mandatory": true
                ],
            [
                "key": "datePickerKey",
                "type": "datePicker",
                "label": "datePicker",
                "mandatory": true
                ],
            [
                "key": ("pickerKey"),
                "type": ("picker"),
                "label": ("picker"),
                "mandatory": true,
                "listOptions": [
                    ["key": "KeyNoSelected",
                     "value": "Select One"],
                    ["key": "GB",
                     "value": "United Kingdom"],
                    ["key": " ",
                     "value": "Other"]
                ]
            ],
          [
                "key": ("textoKey"),
                "type": ("text"),
                "label": ("texto"),
                "mandatory": (true)
            ],
            [
                "key": ("booleanoKey"),
                "type": ("boolean"),
                "label": ("Ich akzeptiere die {* legal_acceptance_URL_2 *} und willige – bis auf Widerruf- in die Erhebung, Verarbeitung und Nutzung meiner personenbezogenen Daten gemäß der {* legal_acceptance_URL_1 *} ein."),
                "validator": ("bool"),
                "mandatory": true
            ],
            [
                "key": ("indexKEY"),
                "type": ("index"),
                "label": ("Ich akzeptiere die {* legal_acceptance_URL_2 *} und willige – bis auf Widerruf- in die Erhebung, Verarbeitung und Nutzung meiner personenbezogenen Daten gemäß der {* legal_acceptance_URL_1 *} ein.")
            ],
            [
                "key": ("booleanoKey2"),
                "type": ("boolean"),
                "label": ("Bolean sin link"),
                "validator": ("bool"),
                "mandatory": true
            ],
            [
                "key": ("textoKey99"),
                "type": ("text"),
                "label": ("text99"),
                "mandatory": (true)
                ],
            [
                "key": ("textoKey88"),
                "type": ("text"),
                "label": ("text88"),
                "mandatory": (true)
                ]
        ]
        
        return emailField
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-- Create form Type with JSON --
        
       // let formulary = Formulary.shared
       // let viewContainterForm = formulary.start(self.button, jsonFile: "json_formulary.json")
       // formulary.delegate = self
 
        
        //-- Create form Type with Array Dic --
        guard let fields = self.prepareField() as? [[String: AnyObject]] else { return }
        let viewContainterForm = self.formulary.start(self.button, listItems: fields)
        self.formulary.formularyOutput = self
        self.formulary.populateData(
            [
                "textoKey2": "rellenar2",
                "textoKey": "rellenar",
                "pickerKey": "GB",
                "booleanoKey": true,
                "datePickerKey": "12/01/1983"
            ]
        )
        
        //-- Insert in view --
        self.scrollView.addSubview(viewContainterForm)
        
        //-- Autolayout --
        gig_autoresize(viewContainterForm, false)
        gig_layout_fit_horizontal(viewContainterForm)
        gig_constrain_width(viewContainterForm, UIScreen.main.bounds.size.width)
        gig_layout_top(viewContainterForm, 0)
        gig_layout_bottom(viewContainterForm, 0)
    }
    
    // MARK: PFormController
    
    func recoverFormModel(_ formValues: [AnyHashable : Any]) {
        print("FORMVALUES: \(formValues)")
        self.view.endEditing(true)
    }
    
    func userDidTapLink(_ key: String) {
        print("RECOVER LINK: \(key)")
    }
    
    func fieldFocus(frame: CGRect, key: String?) {
        print("frame: \(frame) , and Key: \(String(describing: key!))")
    }
    
    // MARK: Actions
    @IBAction func loadError(_ sender: Any) {
        let dicError = [
            "pickerKey": "error 1",
            "key": "error 2"
            ]
        self.formulary.loadError(dicError)
    }
}
