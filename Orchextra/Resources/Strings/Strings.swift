//
//  Strings.swift
//  Orchextra
//
//  Created by Jerilyn Goncalves on 26/06/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

/// Use this struct to customize strings displayed by ORX
public struct Strings {
    
    public var orxAcceptButtonTitle: String
    public var orxCancelButtonTitle: String
    public var orxSettingsButtonTitle: String
    public var orxBackgroundLocationAlertMessage: String
    public var orxScannerTitle: String
    public var orxScannerMessage: String
    public var orxCameraPermissionDeniedTitle: String
    public var orxCameraPermissionDeniedMessage: String
    
    // MARK: - Public init
    
    public init() {
        self.orxAcceptButtonTitle = String()
        self.orxCancelButtonTitle = String()
        self.orxSettingsButtonTitle = String()
        self.orxBackgroundLocationAlertMessage = String()
        self.orxScannerTitle = String()
        self.orxScannerMessage = String()
        self.orxCameraPermissionDeniedTitle = String()
        self.orxCameraPermissionDeniedMessage = String()
    }
    
    public init(orxAcceptButtonTitle: String?, orxCancelButtonTitle: String?, orxSettingsButtonTitle: String?, orxBackgroundLocationAlertMessage: String?, orxScannerTitle: String?, orxScannerMessage: String?, orxCameraPermissionDeniedTitle: String?, orxCameraPermissionDeniedMessage: String?) {
        self.orxAcceptButtonTitle = orxAcceptButtonTitle ?? String()
        self.orxCancelButtonTitle = orxCancelButtonTitle ?? String()
        self.orxSettingsButtonTitle = orxSettingsButtonTitle ?? String()
        self.orxBackgroundLocationAlertMessage = orxBackgroundLocationAlertMessage ?? String()
        self.orxScannerTitle = orxScannerTitle ?? String()
        self.orxScannerMessage = orxScannerMessage ?? String()
        self.orxCameraPermissionDeniedTitle = orxCameraPermissionDeniedTitle ?? String()
        self.orxCameraPermissionDeniedMessage = orxCameraPermissionDeniedMessage ?? String()
    }
}
