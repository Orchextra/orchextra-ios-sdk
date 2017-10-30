//
//  GIGActionSheet.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 2/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
open class ActionSheet: AlertController {
    
    public override init(title: String, message: String) {
        super.init(title: title, message: message, style: .actionSheet)
    }
}
