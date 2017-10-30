//
//  InfiniteCollectionViewCell.swift
//  GIGLibrary
//
//  Created by Jerilyn Goncalves on 10/04/2017.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit

class InfiniteCollectionViewCell: UICollectionViewCell {
    
    var title: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with title: String) {
        
        if self.title == .none {
            let titleLabel = UILabel(frame: self.bounds)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 40.0)
            titleLabel.textColor = .white
            self.addSubviewWithAutolayout(titleLabel)
            self.title = titleLabel
        }
        self.title?.text = title
        self.backgroundColor = #colorLiteral(red: 0.5976799371, green: 0.8920355903, blue: 0.7903682201, alpha: 1)
    }
    
}
