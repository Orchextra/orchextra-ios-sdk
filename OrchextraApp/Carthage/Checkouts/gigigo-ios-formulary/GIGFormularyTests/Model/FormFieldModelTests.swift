//
//  FormFieldModelTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 1/8/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

//swiftlint:disable discouraged_direct_init

import XCTest
@testable import GIGFormulary

class FormFieldModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: Parse Json Tests
    
    // MARK: Mandatory generic  -  FormFieldModel
    
    func test_parseJson_FormFieldModel_with_json_not_valid() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(["": ""]))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_No_All_Mandatory_Element() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(["template": ""]))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_All_Mandatory_Element_empty() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let dic = ["type": "",
                       "label": "",
                       "key": ""] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_All_Mandatory_Element_with_incorrect_type() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let dic = ["type": 0,
                       "label": "aa",
                       "key": "aa"] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
        do {
            let key = ["asa": "asdas"] as [String : Any]
            let dic2 = ["type": "aa",
                        "label": "aa",
                        "key": key] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic2))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_Valid_And_All_Mandatory_Element() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave"] as [AnyHashable: Any]
            
            XCTAssertNotNil(try formFieldModelResult.parseDictionary(dic))
        }
    }
    
    // MARK: Styles
    
    func test_parseJson_FormFieldModel_with_json_valid_And_All_Mandatory_Element_with_styles_empty() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let styles = [AnyObject]()
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "style": styles] as [AnyHashable: Any]
            
            XCTAssertNotNil(try formFieldModelResult.parseDictionary(dic))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_valid_And_All_Mandatory_Element_with_styles() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let styles = ["backgroundColorField": "#ff374b",
                          "sizeTitle": 12] as [String : Any]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "style": styles] as [AnyHashable: Any]
            
            XCTAssertNotNil(try formFieldModelResult.parseDictionary(dic))
            XCTAssertTrue(formFieldModelResult.style?.backgroundColorField == UIColor(fromHexString: "#ff374b"))
        }
    }
    
    // MARK: Options
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_All_Mandatory_Element_options_empty() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let listOptions = [[]]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_All_Mandatory_Element_options_incorrect_type() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let listOptions = ["aa"]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_not_valid_And_All_Mandatory_Element_options_element_empty() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let listOptions = [["key": ""]]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
        do {
            let listOptions = ["value": ""]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic))
        }
        do {
            let listOptions = ["key": "",
                               "value": ""]
            
            let dic1 = ["type": "tipo",
                        "label": "titulo",
                        "key": "clave",
                        "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertThrowsError(try formFieldModelResult.parseDictionary(dic1))
        }
    }
    
    func test_parseJson_FormFieldModel_with_json_valid_And_All_Mandatory_Element_options() {
        let formFieldModelResult = FormFieldModel(bundle: Bundle())
        do {
            let listOptions = [["key": "KeyNoSelected", "value": "elige un elemento"],
                               ["key": "clave1", "value": "titulo primer elemento"]]
            
            let dic = ["type": "tipo",
                       "label": "titulo",
                       "key": "clave",
                       "listOptions": listOptions] as [AnyHashable: Any]
            
            XCTAssertNotNil(try formFieldModelResult.parseDictionary(dic))
        }
    }
}
//swiftlint:enable discouraged_direct_init
