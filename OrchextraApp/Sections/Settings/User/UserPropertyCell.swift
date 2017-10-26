//
//  UserPropertyCell.swift
//  OrchextraApp
//
//  Created by Judith Medina on 24/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import Orchextra


class UserPropertyCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.valueLabel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func bind(key: String, listItems: [ListItem]) {
        self.keyLabel.text = key
        let value = listItems.filter { $0.key == key}
        if let valueText =  value.first?.value {
            self.valueLabel.text = valueText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
