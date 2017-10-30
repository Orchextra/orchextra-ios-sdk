//
//  UserVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary
import GIGFormulary
import Orchextra

class UserVC: UIViewController, UserUI, PFormulary {
    
    // MARK: - Attributtes
    var presenter: UserPresenter?

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formView: UIView!
    
    var listItems: [[AnyHashable: Any]]?
    let formulary = Formulary()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        self.title = "User"
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.formulary.clearFormulary()
    }
    
    func showForm(listItems: [[AnyHashable: Any]]) {
        self.listItems = listItems
        let saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save", for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.formulary.loadBundle(Bundle.main)
        let viewF = self.formulary.start(saveButton, listItems: listItems)
        self.formView.addSubviewWithAutolayout(viewF)
        self.formulary.formularyOutput = self
    }
    
    // MARK: - PFormulary
    
    func recoverFormModel(_ formValues: [AnyHashable: Any]) {
        self.view.endEditing(true)
        self.presenter?.userDidTapSend(with: formValues)
    }
    
}

extension UserVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "UserVC"
}
