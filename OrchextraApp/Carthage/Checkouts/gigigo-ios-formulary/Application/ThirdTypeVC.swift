//
//  ThirdTypeVC.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 17/1/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary
import GIGFormulary

class ThirdTypeVC: UIViewController, Instantiable, PFormulary {
    
    let formulary = Formulary.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formulary.loadBundle(Bundle.main)
        self.formulary.start(self.view, jsonFile: "json_formulary.json")
        self.formulary.formularyOutput = self

    }
    
    
    // MARK: - Instantiable
    
    static var storyboard = "External"
    static var identifier = "ThirdTypeVCID"
        
    
    // MARK: PFormController
    
    func recoverFormModel(_ formValues: [AnyHashable : Any]) {
        print(formValues)
    }
    
    func userDidTapLink(_ key: String) {
        print(key)
    }
    
    
    // MARK: Actions
    
    @IBAction func closeModalAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func populateAction(_ sender: Any) {
        self.formulary.populateData(
            [
                "a": "rellenar2",
                "b": "rellenar",
                "c": "GB",
                "asd": true,
                "d": "rellenar",
                "e": "rellenar",
                "f": "rellenar",
                "g": "rellenar",
                "h": "rellenar",
                "i": "rellenar",
                "j": "a1",
                "k": true,
                "boolK": true,
                "l": "12/01/1983",
                "key1": "rellenar",
                "key2": "rellenar",
                "key3": "rellenar",
                "key4": "rellenar",
                "key5": "rellenar",
                "key6": "rellenar",
                "key7": "rellenar"
            ]
        )
    }
}
