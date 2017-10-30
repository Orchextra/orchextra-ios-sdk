//
//  FormControllerTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 10/4/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import GIGFormulary

class FormControllerTests: XCTestCase {
    
    
    var formController: FormController!
    var buttonMock: UIButton!
    var bundleMock: Bundle!
    var formControllerOutPutMock: FormControllerOutputMock!
    
    override func setUp() {
        super.setUp()

        self.buttonMock = UIButton(
            frame: CGRect(x: 0, y: 0, width: 100, height: 100)
        )
        self.bundleMock = Bundle(for: type(of: self))
        self.formControllerOutPutMock = FormControllerOutputMock()
        
        self.formController = FormController(
            button: self.buttonMock,
            bundle: self.bundleMock
        )
        self.formController.formControllerOutput = self.formControllerOutPutMock
    }
    
    override func tearDown() {
        self.formController = nil
        self.buttonMock = nil
        self.bundleMock = nil
        
        super.tearDown()
    }
    
    func test_formController_whenLoadJsonDic_returnFields() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
              let dicForm = form as? [AnyHashable: Any],
              let listForm = dicForm["fields"] as? [[AnyHashable: Any]]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        
        //ASSERT
        expect(self.formController.formFields.count).to(equal(13))
    }
    
    func test_formController_whenLoadJsonDicAndPopulate_returnFieldsPopulated() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]],
            let populate = JSONMock().getJson(keyJson: "populateForm1"),
            let dicPopulate = populate as? [AnyHashable: Any]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.populateData(dicPopulate)
        
        //ASSERT
        let field = self.formController.formFields[2]
        let value = field.fieldValue as? String
        expect(value).to(equal("value 2"))
    }
    
    func test_formController_whenLoadJsonDicAndLoadError_returnFieldsLoadTextdWithError() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]],
            let error = JSONMock().getJson(keyJson: "errorForm1"),
            let dicerror = error as? [AnyHashable: Any]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.loadError(dicerror)
        
        //ASSERT
        let field = self.formController.formFields[2]
        let textField = field as? TextFormField
        expect(textField?.errorLabel.text).to(equal("error 2"))
    }
    
    func test_formController_whenSendButton_returnValuesForms() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]],
            let populate = JSONMock().getJson(keyJson: "populateForm1"),
            let dicPopulate = populate as? [AnyHashable: Any]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.populateData(dicPopulate)
        self.formController.sendButtonAction()
        
        //ASSERT
        XCTAssertTrue(self.formControllerOutPutMock.recoverFormModelSpy)
        expect(self.formControllerOutPutMock.formValuesOutput?.count).to(equal(13))
    }
    
    func test_formController_whenSendButtonAndItemMandatoryIsNill_returnValuesForms() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.sendButtonAction()
        
        //ASSERT
        XCTAssert(self.formControllerOutPutMock.recoverFormModelSpy == false)
        XCTAssertNil(self.formControllerOutPutMock.formValuesOutput)
    }    
    
    func test_formController_whenRecoverView_returnViewContainer() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "form1"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        let viewContainer = self.formController.recoverView()
        
        //ASSERT
        expect(viewContainer.subviews.count).to(equal(13))
    }
    
    func test_formController_whenCompareItems_returnSuccess() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "fomr2Compare"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]],
            let populate = JSONMock().getJson(keyJson: "populateForm2"),
            let dicPopulate = populate as? [AnyHashable: Any]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.populateData(dicPopulate)
        self.formController.sendButtonAction()
        
        //ASSERT
        XCTAssertTrue(self.formControllerOutPutMock.recoverFormModelSpy)
        XCTAssertTrue(self.formControllerOutPutMock.formValuesOutput?.count == 2)
    }
    
    func test_formController_whenCompareItems_returnInvalidForm() {
        // ARRANGE
        guard let form = JSONMock().getJson(keyJson: "fomr2Compare"),
            let dicForm = form as? [AnyHashable: Any],
            let listForm = dicForm["fields"] as? [[AnyHashable: Any]]
            else { return }
        
        //ACT
        self.formController.loadFieldsFromJSONDictionary(listForm)
        self.formController.sendButtonAction()
        
        //ASSERT
        XCTAssertTrue(self.formControllerOutPutMock.invalidFormSpy)
    }
}
