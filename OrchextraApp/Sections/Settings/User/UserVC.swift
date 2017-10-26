//
//  UserVCVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 17/10/17.
//  Copyright © 2017 Gigigo Mobile Services S.L.. All rights reserved.
//

import UIKit
import GIGLibrary

class UserVC: BaseVC, UserUI {
    
    // MARK: - Attributtes
    var presenter: UserPresenter?

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var listItems: [ListItem]?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        self.title = "User"
        self.hideKeyboardWhenTappedAround()
    }
    
    func updateCell(listItems: [ListItem]) {
        self.listItems = listItems
        self.tableView.reloadData()
    }
}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPropertyCell", for: indexPath) as? UserPropertyCell
        guard let listItems = self.listItems else { return UITableViewCell() }
        let key = listItems[indexPath.row].key
        cell?.bind(key: key, listItems: listItems)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
}

extension UserVC: Instantiable {
    static var storyboard = "Settings"
    static var identifier = "UserVC"
}
