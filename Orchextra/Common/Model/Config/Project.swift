//
//  Project.swift
//  Orchextra
//
//  Created by Judith Medina on 24/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

struct Project {

    var projectId: String?
    var name: String?
    var customFields: [CustomField]?
    
    init(from json: JSON) {
        self.projectId = json["projectId"]?.toString()

        if let customFieldsDic = json["customFields"]?.toDictionary() {
            let keysCustomFields = customFieldsDic.keys
            self.customFields = [CustomField]()
            for key in keysCustomFields {
                
                if let customFieldValue = customFieldsDic[key] as? [String: Any],
                    let customField = CustomField.customField(
                        key: key,
                        json: customFieldValue) {
                    self.customFields?.append(customField)
                }
            }
        }
    }
}
