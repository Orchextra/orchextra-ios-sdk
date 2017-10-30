//
//  AgeValidator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 19/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class AgeValidator: Validator {
    
    override func validate(_ value: Any?) -> Bool {
        if !super.validate(value) {
            return false
        }
        let date = value as? Date
        
        if date == nil && !self.mandatory {
            return true
        }
        
        if date != nil {
            return self.isValidAge(date!)
        }
        
        return true
    }
    
    // MARK: Private Method
    
    fileprivate func isValidAge(_ birthday: Date) -> Bool {
        return calculateAge(birthday) >= self.minAge ? true : false
    }
    
    fileprivate func calculateAge (_ birthday: Date) -> NSInteger {        
        let calendar: Calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        let dateComponentNow: DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth: DateComponents = (calendar as NSCalendar).components(unitFlags, from: birthday)
        
        if (dateComponentNow.month < dateComponentBirth.month) ||
            (dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day) {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        } else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }
}
