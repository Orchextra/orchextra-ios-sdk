//
//  JSONMock.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 10/4/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import UIKit

@testable import GIGFormulary

class JSONMock {
    
    func getJson(keyJson: String) -> Any? {
        let testBundle = Bundle(for: type(of: self))
        
        if let path = testBundle.path(forResource: keyJson, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    return jsonResult
                } catch {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
