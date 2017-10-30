//
//  UIView+Extension.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 7/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


public extension UIView {

    @objc public func addSubviewWithAutolayout(_ childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(childView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                options: .alignmentMask,
                metrics: nil,
                views: ["childView" : childView]
            )
        )
        
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                options: .alignmentMask,
                metrics: nil,
                views: ["childView" : childView]
            )
        )
        
        self.addConstraints(constraints)
        self.setNeedsUpdateConstraints()
    }
    
}
