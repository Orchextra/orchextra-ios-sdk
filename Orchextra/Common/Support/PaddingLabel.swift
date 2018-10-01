//
//  Label+Extension.swift
//  Orchextra
//
//  Created by Judith Medina on 28/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height + contentInset.top + contentInset.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: contentInset))
    }
}
