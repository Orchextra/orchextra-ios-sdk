//
//  ViewController(keyboard_scrollview_resizing).swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 20/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
     // MARK: - IBOutlets
     @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - View life cycle
 override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    self.addNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Private methods
    
    fileprivate func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - NotificationCenter methods
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.size.height, right: 0)
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}
