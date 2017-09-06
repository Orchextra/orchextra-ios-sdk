//
//  FilterTableViewCell.swift
//  Orchextra
//
//  Created by Carlos Vicente on 5/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

@IBDesignable class FilterTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBInspectable @IBOutlet weak var filterNameLabel: UILabel!
    @IBInspectable @IBOutlet weak var filterButton: UIButton!
    
    // MARK: - Attributes
    var presenter: FilterPresenterInput?
    
    // MARK: - Binding
    func bind(name: String, selected: Bool) {
        self.filterNameLabel.text = name
        self.filterButton.isSelected = selected
    }
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "FilterTableViewCell"
    }
    
    // MARK: - IBActions 
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.presenter?.userDidTapFilter(at: self.tag)
    }

}
