//
//  CustomScannerPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 6/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import Orchextra

protocol CustomScannerPresenterInput {
    func viewDidLoad()
    func startModule()
    func userDidTapCloseScanner()
    func scannerDidFinishCapture(value: String, type: String)
    func moduleDidFinish(action: Action?, completionHandler: (() -> Void)?)
    func resetValueScanned()
    func setOutputModule(outputModule: ModuleOutput)
}

protocol CustomScannerUI: class {
    func initializeSubviews()
    func showScanner()
    func stopScanner()
    func showCameraPermissionAlert()
    func show(scannedValue: String, message: String)
    func show(image: String, message: String)
    func hideInfo()
}

enum ScannerType: String {
    case barcode
    case qr
}

class CustomScannerPresenter {
    // MARK: - Public attributes
    weak var view: CustomScannerUI?
    let wireframe: CustomScannerWireframe
    var inputModule: ModuleInput?
    var outputModule: ModuleOutput?
    fileprivate var waitingUntilResponseFromOrx: Bool = false
    
    // MARK: - Initializer
    init(view: CustomScannerUI, wireframe: CustomScannerWireframe, inputModule: ModuleInput) {
        self.view = view
        self.wireframe = wireframe
        self.inputModule = inputModule
    }
}

extension CustomScannerPresenter: CustomScannerPresenterInput {
    func viewDidLoad() {
        self.view?.initializeSubviews()
    }
    
    func startModule() {
        self.resetValueScanned()
        self.view?.showScanner()
    }
    
    func userDidTapCloseScanner() {
        self.wireframe.dismissCustomScanner(completion: nil)
    }
    
    func scannerDidFinishCapture(value: String, type: String) {
        var typeValue = ScannerType.barcode
        if type == "org.iso.QRCode" {
            typeValue = ScannerType.qr
        }
        
        if !self.waitingUntilResponseFromOrx {
            self.waitingUntilResponseFromOrx = true
            
            self.view?.show(scannedValue: value, message: "Scanning...")
            guard let moduleInput = self.inputModule else {
                LogWarn("Custom Scanner ")
                return
            }
            DispatchQueue.global(qos: .background).async {
                self.outputModule?.triggerWasFired(with: ["value": value,
                                                         "type": typeValue.rawValue],
                                                  module: moduleInput)
                LogDebug("Module Scan - has trigger: \(value) - \(type)")
            }
        }
        
    }
    
    func moduleDidFinish(action: Action?, completionHandler: (() -> Void)?) {
        if action != nil {
            self.view?.stopScanner()
            self.wireframe.dismissCustomScanner {
                if let completion = completionHandler {
                    completion()
                }
            }
        } else {
            self.view?.show(image: "custom_fail_cross", message: "Match not found")
            DispatchQueue.global(qos: .background).async {
                if let completion = completionHandler {
                    completion()
                }
            }
        }
    }
    
    func resetValueScanned() {
        self.view?.hideInfo()
        self.waitingUntilResponseFromOrx = false
    }

    func setOutputModule(outputModule: ModuleOutput) {
        self.outputModule = outputModule
    }
}
