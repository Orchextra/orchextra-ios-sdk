//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerVC: UIViewController, ScannerUI {
    // MARK: - IBOutlets
    @IBOutlet weak var orchextraScannerButton: UIButton!
    
    @IBOutlet weak var customScannerButton: UIButton!

    @IBOutlet weak var imageRecognitionButton: UIButton!
    
    // MARK: - Attributtes    
    var presenter: ScannerPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        
        //TODO: Show or hide image recognition using Vuforia if it is not available
    }
    
    // MARK: - Actions
    
    @IBAction func orchextraScannerTapped(_sender: Any) {
        self.presenter?.userDidTapOrchextraScanner()
    }
    
    @IBAction func customScannerTapped(_sender: Any) {
        let alert = Alert(title: "OrchextraApp", message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,")
        alert.addDefaultButton("OK", usingAction: nil)
        alert.show()
//        self.presenter?.userDidTapCustomScanner()
    }
    
    @IBAction func imageRecognitionTapped(_sender: Any) {
        self.presenter?.userDidTapImageRecognition()
    }
}

extension ScannerVC: Instantiable {
    
    // MARK: - Instantiable
    
    public static func storyboard() -> String {
        return "Triggering"
    }
    
    public static func identifier() -> String? {
        return "ScannerVC"
    }
}
