//
//  ViewController.swift
//  OrchextraApp
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import Orchextra

class ViewController: UIViewController {
    
    let orchextra = Orchextra.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orchextra.logLevel = .debug
        self.orchextra.logStyle = .funny
        self.orchextra.environment = .quality
        
        self.orchextra.start(with: "key", apiSecret: "secret") { result in
            switch result {
            case .success:
                print("Orchextra has been initialized correctly")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func openScanner(_ sender: AnyObject) {
            self.orchextra.openScanner()
    }
}
