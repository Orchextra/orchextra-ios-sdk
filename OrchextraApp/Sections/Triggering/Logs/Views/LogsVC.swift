//
//  LogsVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class LogsVC: UIViewController {
    // MARK: - Attributtes
    var presenter: LogsPresenterInput?
    
    // MARK: IBOutlets
    @IBOutlet weak var filterCheckmark: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var clearFiltersButton: UIButton!
    @IBOutlet weak var triggersTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.viewWillAppear()
    }    
}

extension LogsVC: LogsUI {
    func updateTriggerList() {
        self.triggersTableView.reloadData()
        self.presenter?.triggerListHasBeenUpdated()
    }
}

extension LogsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.tableViewNumberOfElements() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elements = self.presenter?.tableViewElements()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogTableViewCell.identifier(), for: indexPath) as? LogTableViewCell,
            let element = elements?[indexPath.row],
            let elementViewModel = TriggerViewModelFactory.triggerViewModel(from: element) else {
            return UITableViewCell()
        }
        cell.bindTriggerViewModel(elementViewModel)
        return cell
    }
}

extension LogsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension LogsVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Triggering"
    }
    
    public static func identifier() -> String? {
        return "LogsVC"
    }
}
