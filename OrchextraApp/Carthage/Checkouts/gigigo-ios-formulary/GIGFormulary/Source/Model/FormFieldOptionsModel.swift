//
//  FormFieldOptionsModel.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 29/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class FormFieldOptionsModel: NSObject {
    var idOption: String?
    var textOption: String?
    
    // MARK: Public methods
    
    class func parseListOptionsJson(_ json: [[AnyHashable: Any]]) throws ->[FormFieldOptionsModel] {
        do {
            return try (json.map(parseOptionsJson))              
        } catch (let throwError) {
            throw throwError
        }
    }
    
    class func parseOptionsJson(_ json: [AnyHashable: Any]) throws -> FormFieldOptionsModel {
        let activity = FormFieldOptionsModel()
        
        do {
            return try self.parseOption(json, activity: activity)
        } catch (let throwError) {
            throw throwError
        }
    }
    
    class func parseOption(_ json: [AnyHashable: Any], activity: FormFieldOptionsModel) throws ->  FormFieldOptionsModel {
        
        //== PREPARE DATA ==
        //-- Mandatory --
        guard let key = json["key"] as? String, key.characters.count > 0 else {
            LogWarn(" FormFieldOptionsModel:: key value Not Found")
            throw ThrowError.mandatoryElementNotFound
        }
        
        guard let value = json["value"] as? String else {
            LogWarn(" FormFieldOptionsModel:: value Options Not Found")
            throw ThrowError.mandatoryElementNotFound
        }
        
        if value.characters.count == 0 {
            LogWarn("FormFieldOptionsModel:: value Options is empty")
        }
        
        //== INSERT DATA ==
        //-- Mandatory--
        activity.idOption = key
        activity.textOption = NSLocalizedString(value, comment: "")

        return activity
    }
}
