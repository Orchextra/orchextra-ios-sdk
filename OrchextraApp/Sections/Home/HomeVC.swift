//
//  HomeVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class HomeVC: UIViewController {
    
    // MARK: - Attributtes
    
    var presenter: HomePresenterInput?
    var activeTextField: UITextField?
    
    // MARK: - IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var orchextraImageView: UIImageView!
    @IBOutlet weak var orchextraLabel: UILabel!
    @IBOutlet weak var projectTextfield: UITextField!
    @IBOutlet weak var apiKeyTextfield: UITextField!
    @IBOutlet weak var apiSecretTextfield: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.startButton.layer.cornerRadius = 6.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.addNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_sender: Any) {
        let apiKey = self.apiKeyTextfield.text
        let apiSecret = self.apiSecretTextfield.text
        self.presenter?.userDidTapStart(with: apiKey, apiSecret: apiSecret)
    }
    
    fileprivate func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    // MARK :  NotificationCenter methods
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0);
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        })
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeVC: HomeUI {
    func showAlert(message: String) {
        let alert = Alert(title: "OrchextraApp", message: message)
        alert.addDefaultButton("OK", usingAction: nil)
        alert.show()
    }
    
    func initializeTextFieldTextsByDefault() {
        self.projectTextfield.text = Constants.projectName
        self.apiKeyTextfield.text = Constants.apiKey
        self.apiSecretTextfield.text = Constants.apiSecret
    }
}

extension HomeVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Home"
    }
    
    public static func identifier() -> String? {
        return "HomeVC"
    }
}
