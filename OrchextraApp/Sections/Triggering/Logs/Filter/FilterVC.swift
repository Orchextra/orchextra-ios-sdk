//
//  FilterVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class FilterVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Attributtes
    
    var presenter: FilterPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filter"
        self.presenter?.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func userDidTapCancel(_ sender: Any) {
        self.presenter?.userDidTapCancel()
    }
    
    @IBAction func userDidTapSave(_ sender: Any) {
        self.presenter?.userDidTapSave()
    }
}

extension FilterVC: FilterUI {
    func reloadFilter(at position: Int) {
        let indexPath = IndexPath(row: position, section: 0)
        self.filterTableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension FilterVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.tableViewNumberOfElements() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filters = self.presenter?.tableViewElements()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier(), for: indexPath) as? FilterTableViewCell,
            let filter = filters?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.tag = indexPath.row
        cell.presenter = self.presenter
        cell.bind(name: filter.name, selected: filter.selected)
        
        return cell
    }
}

extension FilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filters = self.presenter?.tableViewElements()
        guard let filter = filters?[indexPath.row] else { return }
        
        self.presenter?.userDidTap(filter: filter, at: indexPath.row)
    }
}

extension FilterVC: Instantiable {
    
    // MARK: - Instantiable
    
    static var storyboard = "Filter"
    static var identifier = "FilterVC"

}
