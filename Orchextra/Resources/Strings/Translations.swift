//
//  Translations.swift
//  Orchextra
//
//  Created by Jerilyn Goncalves on 26/06/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

/// Use this struct to customize strings displayed by ORX
public struct Translations {
    
    public var acceptButtonTitle: String
    public var cancelButtonTitle: String
    public var settingsButtonTitle: String
    public var backgroundLocationAlertMessage: String
    public var scannerTitle: String
    public var scannerMessage: String
    public var cameraPermissionDeniedTitle: String
    public var cameraPermissionDeniedMessage: String
    
    // MARK: - Public init
    
    public init() {
        self.acceptButtonTitle = String()
        self.cancelButtonTitle = String()
        self.settingsButtonTitle = String()
        self.backgroundLocationAlertMessage = String()
        self.scannerTitle = String()
        self.scannerMessage = String()
        self.cameraPermissionDeniedTitle = String()
        self.cameraPermissionDeniedMessage = String()
    }
    
    public init(acceptButtonTitle: String?, cancelButtonTitle: String?, settingsButtonTitle: String?, backgroundLocationAlertMessage: String?, scannerTitle: String?, scannerMessage: String?, cameraPermissionDeniedTitle: String?, cameraPermissionDeniedMessage: String?) {
        self.acceptButtonTitle = acceptButtonTitle ?? String()
        self.cancelButtonTitle = cancelButtonTitle ?? String()
        self.settingsButtonTitle = settingsButtonTitle ?? String()
        self.backgroundLocationAlertMessage = backgroundLocationAlertMessage ?? String()
        self.scannerTitle = scannerTitle ?? String()
        self.scannerMessage = scannerMessage ?? String()
        self.cameraPermissionDeniedTitle = cameraPermissionDeniedTitle ?? String()
        self.cameraPermissionDeniedMessage = cameraPermissionDeniedMessage ?? String()
    }
}
