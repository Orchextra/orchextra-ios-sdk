//
//  ProgressVC.swift
//  GIGLibrary
//
//  Created by José Estela on 22/3/17.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class ProgressVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressPageControl: ProgressPageControl!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressPageControl.currentPage = 0
    }
    
    // MARK: - Actions
    
    @IBAction func animateProgress(sender: UIButton) {
        self.progressPageControl.startCurrentPage(withDuration: 10, fromZero: false)
    }
    
    @IBAction func pauseProgress(sender: UIButton) {
        self.progressPageControl.pauseCurrentPage()
    }
    
    @IBAction func nextPage(sender: UIButton) {
        self.progressPageControl.currentPage += 1
    }
}
