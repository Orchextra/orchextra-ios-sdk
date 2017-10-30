//
//  GIGDateExtensionTests.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 17/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
@testable import GIGLibrary


class GIGDateExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	
	// MARK: - DateFromString tests
    func test_returnsNil_whenFormatIsWrong() {
		let dateString = "wrong format"
		
		let date = Date.dateFromString(dateString)
		
		XCTAssert(date == nil)
    }
	
	func test_returnsCorrectDate_whenFormatIsCorrect() {
		let dateString = "1985-01-24T12:00:00Z"
		
		let date = Date.dateFromString(dateString)
		
		XCTAssert(date != nil)
		XCTAssert(date == alejandroBirthday())
	}
	
	
	// MARK: - Adding days tests
	
	func test_returnsNextDay_whenAddOneDay() {
		let dateString = "1985-01-24T12:00:00Z"
		let date = Date.dateFromString(dateString)!
		
		let nextDay = date + 1
		
		XCTAssert(nextDay == alejandroBirthdayNextDay())
	}
	
	func test_returnsPreviusDay_whenSubstractOneDay() {
		let dateString = "1985-01-25T12:00:00Z"
		let date = Date.dateFromString(dateString)!
		
		let nextDay = date - 1
		
		XCTAssert(nextDay == alejandroBirthday())
	}
	
	
	/// MARK: - Comparing dates tests
	
	func test_returnsTrue_whenAskIfTomorrowIsGreatherThanToday() {
		let today = Date.today()
		let tomorrow = today + 1
		
		XCTAssert(tomorrow > today)
	}
	
	func test_returnsFalse_whenAskIfTodayIsGreatherThanToday() {
		let today = Date.today()
		
		XCTAssert((today > today) == false)
	}
	
	func test_returnsTrue_whenAskIfTodayIsMinorThanTomorrow() {
		let today = Date.today()
		let tomorrow = today + 1
		
		XCTAssert(today < tomorrow)
	}
	
	func test_returnsFalse_whenAskIfTodayIsLessThanToday() {
		let today = Date.today()
		
		XCTAssert((today < today) == false)
	}
	
	
	// MARK: - Setting time tests
	
	func test_returns14PM_whenSetting14PM() {
		let date = self.alejandroBirthday()
		
		let resultDate = try! date.setHour(14)
		let expectedDate = Date.dateFromString("1985-01-24T14:00:00", format: "yyyy-MM-dd'T'HH:mm:ss")!
		
		XCTAssert(resultDate == expectedDate, "result: \(resultDate) - expected: \(expectedDate)")
	}
	
	func test_returns14_03_10PM_whenSetting14_59_59PM() {
		let date = self.alejandroBirthday()
		
		let resultDate = try! date.setHour(14, minutes: 59, seconds: 59)
		let expectedDate = Date.dateFromString("1985-01-24T14:59:59", format: "yyyy-MM-dd'T'HH:mm:ss")!
		
		XCTAssert(resultDate == expectedDate, "result: \(resultDate) - expected: \(expectedDate)")
	}
	
	func test_throwsError_whenSetting24PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(24))
	}
	
	func test_throwsError_whenSetting14_60PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 60))
	}
	
	func test_throwsError_whenSetting14_03_60PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 3, seconds: 60))
	}
	
	func test_throwsError_whenSettingNegativeHour() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(-3))
	}
	
	func test_throwsError_whenSettingNegativeMinutes() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: -10))
	}
	
	func test_throwsError_whenSettingNegativeSeconds() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 3, seconds: -1))
	}
	
	
	// MARK: - Private Helpers
	fileprivate func alejandroBirthday() -> Date {
		var dateComponents = DateComponents()
		dateComponents.day = 24
		dateComponents.month = 1
		dateComponents.year = 1985
		dateComponents.hour = 12
		dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
		
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		return calendar.date(from: dateComponents)!
	}
	
	fileprivate func alejandroBirthdayNextDay() -> Date {
		var dateComponents = DateComponents()
		dateComponents.day = 25
		dateComponents.month = 1
		dateComponents.year = 1985
		dateComponents.hour = 12
		dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
		
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		return calendar.date(from: dateComponents)!
	}

}
