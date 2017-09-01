//
//  JSONHandler.swift
//  Orchextra
//
//  Created by Judith Medina on 31/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class JSONHandler {
    
    func jsonFrom(filename: String) -> [String: Any]? {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            LogWarn("\(filename) not found")
            return nil
        }
        
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to String")
            return nil
        }
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to NSData")
            return nil
        }
        
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            LogWarn("Unable to convert \(filename) to JSON dictionary")
            return nil
        }
        return jsonDictionary
    }
    
}
