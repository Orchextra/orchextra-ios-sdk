//
//  FormViews.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary


protocol PFormBuilderViews {
    func sendButtonAction()
}

class FormBuilderViews: NSObject {
    //-- Views --
    let viewContainerFormulary: UIView
    var viewFormulary = UIView()
    var scrollView = UIScrollView()
    var buttonSend = UIButton()
    var viewContainerField = UIView()
    let notificationCenter = NotificationCenter.default
    
    //-- Var --
    var formBuilderViewsOutput: PFormBuilderViews?
    
    // MARK: Init
    
    init(viewContainerFormulary: UIView, formController: FormController) {
        self.viewContainerFormulary = viewContainerFormulary
        
        super.init()
        
        self.prepareFormulary()
        self.initializeConstraints()
        self.events()
        self.notifications()
        self.formBuilderViewsOutput = formController
    }
    
    init (button: UIButton, formController: FormController) {
        self.viewContainerFormulary = UIView()
        self.buttonSend = button
        
        super.init()
        
        self.events()
        self.notifications()
        self.formBuilderViewsOutput = formController
    }
    
    // MARK: Public Method
    
    func updateFormularyContent(_ listFields: [FormField]) {
        self.viewContainerFormulary.removeFromSuperview()
        self.addFields(listFields)
    }
    
    func scrollRectToVisible(_ field: FormField) {
        self.scrollView.scrollRectToVisible(field.frame, animated: true)
    }
    
    func changeFocusField(_ field: FormField?) {
        if field != nil {
            if field?.canBecomeFirstResponder == true {
                field?.becomeFirstResponder()
            } else {
                self.viewContainerFormulary.endEditing(true)
            }
        } else {
            self.viewContainerFormulary.endEditing(true)
        }
    }
    
    func clearFormulary() {
        self.notificationCenter.removeObserver(self)
    }
    
    //-- Second type formulary --
    
    func recoverViewContainer() -> UIView {
        return self.viewContainerField
    }
    
    // MARK: Actions
    
    @objc func buttonAction() {
        self.viewContainerFormulary.endEditing(true)
        self.formBuilderViewsOutput?.sendButtonAction()
    }
    
    // MARK: Private Method
    
    fileprivate func prepareFormulary() {
        if self.viewContainerFormulary.subviews.count > 0 {
            self.viewFormulary = self.viewContainerFormulary.subviews[0]
            if self.viewFormulary.subviews.count > 1 {
                self.viewContainerField = self.viewFormulary.subviews[1]
                guard let button = self.viewFormulary.subviews[2] as? UIButton else { return LogWarn("Button missing") }
                self.buttonSend = button
            } else {
                LogWarn("ViewFormFields or Button send Not Found. Create this in StoryBoard")
            }
        } else {
            LogWarn("ViewContainerFormulary Not Found")
        }
        
        self.viewContainerFormulary.removeSubviews()
    }
    
    fileprivate func notifications() {
        self.notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func events() {
        self.buttonSend.addTarget(self, action: #selector(self.buttonAction), for: UIControlEvents.touchUpInside)
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideComponent)))
        self.viewContainerField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideComponent)))
    }
    
    @objc func hideComponent() {
        self.scrollView.endEditing(true)
        self.viewContainerField.endEditing(true)
    }
    
    fileprivate func initializeConstraints() {
        self.scrollView.addSubview(self.viewFormulary)
        self.viewContainerFormulary.addSubview(self.scrollView)
    
        //-- Constraint --
        gig_autoresize(self.viewFormulary, false)
        gig_layout_fit_horizontal(self.viewFormulary)
        gig_layout_top(self.viewFormulary, 0)
        gig_layout_bottom(self.viewFormulary, 0)
        gig_constrain_width(self.viewFormulary, UIScreen.main.bounds.size.width)
    
        gig_autoresize(self.scrollView, false)
        gig_layout_fit_horizontal(self.scrollView)
        gig_layout_top(self.scrollView, 0)
        gig_layout_bottom(self.scrollView, 0)
    }
    
    func addFields(_ listFields: [FormField]) {
        var lastView = UIView()
        var firstTime = true
        for field in listFields {
            field.viewPpal = self.viewContainerFormulary
            self.viewContainerField.addSubview(field)
            
            gig_autoresize(field, false)
            gig_layout_fit_horizontal(field)
            
            if !firstTime {
                gig_layout_below(field, lastView, 3)
            } else {
                gig_layout_top(field, 0)
            }
            
            lastView = field
            firstTime = false
        }
        
        if self.viewContainerField.subviews.count > 0 {
            gig_layout_bottom(lastView, 0)
        }
    }
    
    
    // MARK: NOTIFICATIONS
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let dict: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        guard let s: NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue else { return LogWarn("keyboardWillShow NSValue parse error")}
        let keyboardFrame: CGRect = s.cgRectValue
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0)
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        }) 
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let position = 64 - (UIScreen.main.bounds.height - self.viewContainerFormulary.bounds.height)
        self.scrollView.contentInset = UIEdgeInsets.init(top: position, left: 0, bottom: 0, right: 0)
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}
