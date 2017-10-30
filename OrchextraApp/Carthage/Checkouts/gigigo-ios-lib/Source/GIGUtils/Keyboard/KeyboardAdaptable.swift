//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit


public protocol KeyboardAdaptable {
	
	func keyboardWillShow()
	func keyboardDidShow()
	
	func keyboardWillHide()
	func keyboardDidHide()
	
}


public extension KeyboardAdaptable where Self: UIViewController {
	
	// MARK: - Public Methods
	
	/// Must call this method on viewWillAppear
	public func startKeyboard() {
		self.manageKeyboardShowEvent()
		self.manageKeyboardHideEvent()
	}
	
	/// Must call this method on viewWillDisappear
	public func stopKeyboard() {
		Keyboard.removeObservers()
	}
	
	// MARK: - Optional Public Methods
	func keyboardWillShow(){}
	func keyboardDidShow(){}
	func keyboardWillHide(){}
	func keyboardDidHide(){}
	
	
	// MARK: - Private Helpers
	
	fileprivate func manageKeyboardShowEvent() {
		Keyboard.willShow { notification in
			guard let size = Keyboard.size(notification) else {
				return LogWarn("Couldn't get keyboard size")
			}
			
			self.keyboardWillShow()
			
			self.animateKeyboardChanges(notification,
				changes: {
					var appHeight = UIApplication.shared.keyWindow?.height()
					if self.navigationController != nil {
						appHeight = appHeight! - 64
					}
					self.view.setHeight(appHeight! - size.height)
				},
				onCompletion: {
					self.keyboardDidShow()
				}
			)
		}
	}
	
	fileprivate func manageKeyboardHideEvent() {
		Keyboard.willHide { notification in
			self.keyboardWillHide()
			
			self.animateKeyboardChanges(notification,
				changes:  {
					var appHeight = UIApplication.shared.keyWindow?.height()
					if self.navigationController != nil {
						appHeight = appHeight! - 64
					}
					self.view.setHeight(appHeight!)
				},
				onCompletion: {
					self.keyboardDidHide()
				}
			)
		}
	}
	
	fileprivate func animateKeyboardChanges(_ notification: Notification, changes: @escaping () -> Void, onCompletion: @escaping () -> Void) {
		let duration = Keyboard.animationDuration(notification)
		let curve = Keyboard.animationCurve(notification)
		
		UIView.animate(
			withDuration: duration,
			delay: 0,
			options: curve,
			animations: {
				changes()
				self.view.layoutIfNeeded()
			},
			completion: { _ in
				onCompletion()
			}
		)
	}
}


class Keyboard {
	
	fileprivate static var observers: [AnyObject] = []
	
	class func removeObservers() {
		for observer in self.observers {
			NotificationCenter.default.removeObserver(observer)
		}
		
		self.observers.removeAll()
	}
	
	class func willShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardWillShow.rawValue, notificationHandler: notificationHandler)
	}
	
	class func didShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardDidShow.rawValue, notificationHandler: notificationHandler)
	}
	
	class func willHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardWillHide.rawValue, notificationHandler: notificationHandler)
	}
	
	class func size(_ notification: Notification) -> CGSize? {
		guard
			let info = (notification as NSNotification).userInfo,
			let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }
		
		return frame.cgRectValue.size
	}
	
	class func animationDuration(_ notification: Notification) -> TimeInterval {
		guard
			let info = (notification as NSNotification).userInfo,
			let value = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				LogWarn("Couldn't get keyboard animation duration")
				return 0
		}
		
		return value.doubleValue
	}
	
	class func animationCurve(_ notification: Notification) -> UIViewAnimationOptions {
		guard
			let info = (notification as NSNotification).userInfo,
			let curveInt = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
			let curve = UIViewAnimationCurve(rawValue: curveInt)
			else {
				LogWarn("Couldn't get keyboard animation curve")
				return .curveEaseIn
		}
		
		return curve.toOptions()
	}
	
	
	// MARK - Private Helpers
	
	fileprivate class func keyboardEvent(_ event: String, notificationHandler: @escaping (Notification) -> Void) {
		let observer = NotificationCenter.default
			.addObserver(
				forName: NSNotification.Name(rawValue: event),
				object: nil,
				queue: OperationQueue.main,
				using: notificationHandler
		)
        
		self.observers.append(observer)
	}
	
}

extension UIViewAnimationCurve {
	func toOptions() -> UIViewAnimationOptions {
		return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
	}
}
