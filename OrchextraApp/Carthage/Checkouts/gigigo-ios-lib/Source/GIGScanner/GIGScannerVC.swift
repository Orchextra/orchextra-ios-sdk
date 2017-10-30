//
//  GIGScannerVC.swift
//  Orchextra
//
//  Created by Judith Medina on 23/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import AVFoundation


public protocol GIGScannerOutput {
    func didSuccessfullyScan(_ scannedValue: String, type: String)
}

open class GIGScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    open var scannerOutput: GIGScannerOutput?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var codeFrameView: UIView?
    var captureDevice: AVCaptureDevice!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession = AVCaptureSession()
            self.captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.upce,
                                                         AVMetadataObject.ObjectType.code39,
                                                         AVMetadataObject.ObjectType.code39Mod43,
                                                         AVMetadataObject.ObjectType.ean13,
                                                         AVMetadataObject.ObjectType.ean8,
                                                         AVMetadataObject.ObjectType.code93,
                                                         AVMetadataObject.ObjectType.code128,
                                                         AVMetadataObject.ObjectType.pdf417,
                                                         AVMetadataObject.ObjectType.aztec,
                                                         AVMetadataObject.ObjectType.qr]
            
            self.addPreviewLayer()
            
        } catch {
            LogWarn("Error initialize camera")
            return
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - PUBLIC
    
    public func startScanning() {
        self.captureSession?.startRunning()
    }
    
    public func stopScanning() {
        self.captureSession?.stopRunning()
    }
    
    public func enableTorch(_ enable: Bool) {
        
        try? self.captureDevice.lockForConfiguration()
        
        if self.captureDevice.hasTorch {
            
            if enable {
                self.captureDevice.torchMode = .on
            } else {
                self.captureDevice.torchMode = .off
            }
        }
        self.captureDevice.unlockForConfiguration()
    }
    
    public func focusCamera(_ focusPoint: CGPoint) {
        
        do {
            try self.captureDevice.lockForConfiguration()
            self.captureDevice.focusPointOfInterest = focusPoint
            self.captureDevice.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
            self.captureDevice.exposurePointOfInterest = focusPoint
            self.captureDevice.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func isCameraAvailable(completion: @escaping (Bool) -> Void) {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            self.requestCameraAccess(completion: completion)
        }
    }
    
    // MARK: - PRIVATE
    
    private func addPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.frame = self.view.bounds
        guard let preview = self.previewLayer else {
            LogWarn("We couldn't add preview layer in the view")
            return }
        self.view.layer.addSublayer(preview)
    }
    
    private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
            completion(success)
        })
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects {
            
            let readableCode = metadata as? AVMetadataMachineReadableCodeObject
            guard   let value = readableCode?.stringValue,
                let type = readableCode?.type
                else {return}
            
            self.scannerOutput?.didSuccessfullyScan(value, type: type.rawValue)
        }
    }
}

