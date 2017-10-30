//
//  NSDate+AlwaysOn.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


public let DateISOFormat = "yyyy-MM-dd'T'HH:mm:ssZ"


/**
Error type for invalid values

Cases:
* InvalidHour: Throws when the hour set is not in 0..24 range
* InvalidMinutes: Throws when the hour set is not in 0..60 range
* InvalidSeconds: Throws when the hour set is not in 0..60 range

- Author: Alejandro Jiménez
- Since: 1.1.3
*/
public enum ErrorDate: Error {
	case invalidHour
	case invalidMinutes
	case invalidSeconds
}

public extension Date {
	
	/// Date from string with ISO format.
	public static func dateFromString(_ dateString: String, format: String = DateISOFormat) -> Date? {
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = format

		let date = dateFormat.date(from: dateString)
		return date
	}
	
	public static func today() -> Date {
		return Date()
	}
	
	public func string(with format: String = DateISOFormat) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.amSymbol = ""
		dateFormatter.pmSymbol = ""
		return dateFormatter.string(from: self)
	}
	
	
	/**
	Set the time to a NSDate
	
	- parameters:
		- hour: The hour to be set
		- minutes: The minutes to be set. Optional, 0 by default
		- seconds: The seconds to be set. Optional, 0 by default
	
	- important: The time is set in local time respecting the user time zone.
	Examples (in Spain):
	* setHour(14) to a summer date (UTC+2) returns -> 12:00:00 +0000
	* setHour(14) to a winter date (UTC+1) returns -> 13:00:00 +0000
	
	- throws: An error of type ErrorDate
	- returns: A new NSDate with the same date and the time set.
	- Author: Alejandro Jiménez
	- Since: 1.1.3
	*/
	public func setHour(_ hour: Int, minutes: Int = 0, seconds: Int = 0) throws -> Date {
		guard 0 <= hour && hour < 24		else { throw ErrorDate.invalidHour }
		guard 0 <= minutes && minutes < 60	else { throw ErrorDate.invalidMinutes }
		guard 0 <= seconds && seconds < 60	else { throw ErrorDate.invalidSeconds }
		
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		var components = (calendar as NSCalendar).components(([.day, .month, .year]), from: self)
		components.hour = hour
		components.minute = minutes
		components.second = seconds
		
		return calendar.date(from: components)!
	}
}


/// Add days to a date
public func +(date: Date, days: Int) -> Date {
	let newDate = (date as NSDate).addingDays(days)
	return newDate!
}

/// Substract days to a date
public func -(date: Date, days: Int) -> Date {
	let newDate = date + (-days)
	return newDate
}


//public func >(lhs: Date, rhs: Date) -> Bool {
//	let result = lhs.compare(rhs)
//	
//	switch result {
//	case .orderedDescending:
//		return true
//	
//	default:
//		return false
//	}
//}
//
//public func <(lhs: Date, rhs: Date) -> Bool {
//	let result = lhs.compare(rhs)
//	
//	switch result {
//	case .orderedAscending:
//		return true
//		
//	default:
//		return false
//	}
//}
//
//public func ==(lhs: Date, rhs: Date) -> Bool {
//	let result = lhs.compare(rhs)
//	
//	switch result {
//	case .orderedSame:
//		return true
//		
//	default:
//		return false
//	}
//}
