//
//  ViewController.swift
//  Application
//
//  Created by  Eduardo Parada on 29/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGFormulary

class ViewController: UIViewController, PFormulary {
    let formulary = Formulary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //-- Create form Type with JSON --
       
         self.formulary.start(self.view, jsonFile: "json_formulary.json")
         self.formulary.formularyOutput = self

        
        //-- Create form Type with Array Dic --
        /*
        let dic1:[String: AnyObject] = ["key": "a1",
                    "type": "text",
                    "label": "validador sin",
                    "mandatory": true]
        
        let dic2:[String: AnyObject]  = ["key": "a2",
                    "type": "text",
                    "label": "validador email",
                    "validator": "email",
                    "mandatory": true]
        
        let dic3:[String: AnyObject]  = ["key": "a3",
                    "type": "text",
                    "label": "validador custom",
                    "validator": "customValidator",
                    "customValidator": "^([0-9])+$",
                    "mandatory": true]
        
        let style:[String: AnyObject] = ["sizeTitle": 30 as CGFloat] as [String : AnyObject]
        let dic4:[String: AnyObject] = ["key" : "key",
                   "label": "label",
                   "type" : "index",
                   "style": style]
 
        let formulary = Formulary.shared
        formulary.start(self.view, listItems: [dic1, dic2, dic4 ,dic3])
        formulary.delegate = self
        */
        
        
        //-- Case: Populate data --
        //let dic = ["a1":"eduardo"]
        //formulary.populateData(dic)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.formulary.clearFormulary()
    }

    // MARK: Action
    
    @IBAction func loadError(_ sender: Any) {
        let dicError = [
            "a1": "Ten adres e-mail jest juz w uzyciu. Zamaturgi a adres email chaquete y atunes",
            "f": "error 2"
        ] as [String : String]
        self.formulary.loadError(dicError)
    }
    
    // MARK: PFormController
    
    func recoverFormModel(_ formValues: [AnyHashable : Any]) {        
        print("FORMVALUES: \(formValues)")
    }
     // OPTIONAL
    func userDidTapLink(_ key: String) {
        print("userDidTapLink: \(key)")
    }
}
