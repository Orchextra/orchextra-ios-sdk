//
//  MenuSectionCell.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class MenuSectionCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var imageMenuSection: UIImageView!
    @IBOutlet weak fileprivate var labelMenuSection: UILabel!
	@IBOutlet weak fileprivate var viewSelector: UIView!
    
	
	override func awakeFromNib() {
		self.viewSelector.backgroundColor = SlideMenuConfig.shared.sectionSelectorColor
	}
	
	
    func bindMenuSection(_ menuSection: MenuSection) {
        self.labelMenuSection.text = menuSection.name
        self.imageMenuSection.image = menuSection.icon
        
        guard let modeButtonType = menuSection.modeButtonType else {
            return
        }
        
        if modeButtonType {
            self.viewSelector.backgroundColor = UIColor.clear
        } else {
            self.viewSelector.backgroundColor = SlideMenuConfig.shared.sectionSelectorColor
        }
        
        if let menuTitleColor = SlideMenuConfig.shared.menuTitleColor {
            self.labelMenuSection.textColor = menuTitleColor
        }
    }
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
        if selected {
            self.viewSelector.alpha = 1
            
            if let colorHightLight = SlideMenuConfig.shared.menuHighlightColor {
                self.labelMenuSection.textColor = colorHightLight
            }
        } else {
            self.viewSelector.alpha = 0
            
            if let menuTitleColor = SlideMenuConfig.shared.menuTitleColor {
                self.labelMenuSection.textColor = menuTitleColor
            }
        }
	}
}
