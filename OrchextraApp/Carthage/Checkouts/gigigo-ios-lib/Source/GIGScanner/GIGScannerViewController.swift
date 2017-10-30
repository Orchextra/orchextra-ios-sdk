//
//  GIGScannerViewController.swift
//  GiGLibrary
//
//  Created by Judith Medina on 7/5/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import AVFoundation

public protocol GIGScannerDelegate {
    
    func didSuccessfullyScan(_ scannedValue: String, tye: String)
}

open class GIGScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var delegate: GIGScannerDelegate?
    fileprivate let session: AVCaptureSession
    fileprivate let device: AVCaptureDevice
    fileprivate let output: AVCaptureMetadataOutput
    fileprivate var preview: AVCaptureVideoPreviewLayer?
    fileprivate var input: AVCaptureDeviceInput?

    
    // MARK: - INIT
    
    required public init?(coder aDecoder: NSCoder) {
        
        self.session = AVCaptureSession()
        self.device = AVCaptureDevice.default(for: AVMediaType.video)!
        self.output = AVCaptureMetadataOutput()
        
        do {
            self.input = try AVCaptureDeviceInput(device: device)
        }
        catch _ {
            //Error handling, if needed
        }
        
        super.init(coder: aDecoder)
    }
    
    deinit {
        
    }
    
    override open func viewDidLoad() {
        self.setupScannerWithProperties()
    }
    
    
    // MARK: - PUBLIC
    
    public func isCameraAvailable() -> Bool {
        
       let authCamera = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authCamera {
            
        case AVAuthorizationStatus.authorized:
            return true
            
        case AVAuthorizationStatus.denied:
            return false
            
        case AVAuthorizationStatus.restricted:
            return false
            
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
//                return true
            })
            return true
        }
    }
    
    public func setupScanner(_ metadataObject: [AnyObject]?) {
        guard let metadata = metadataObject as? [AVMetadataObject.ObjectType] else {return}
        self.output.metadataObjectTypes = metadata
        
        if self.output.availableMetadataObjectTypes.count > 0 {
            self.output.metadataObjectTypes = metadata
        }
    }
    
    public func startScanning() {
        self.session.startRunning()
    }
    
    public func stopScanning() {
        self.session.stopRunning()
    }
    
    public func enableTorch(_ enable: Bool) {

        try! self.device.lockForConfiguration()
        
        if self.device.hasTorch {
            
            if enable {
                self.device.torchMode = .on
            }
            else {
                self.device.torchMode = .off
            }

        }
        
        self.device.unlockForConfiguration()
    }
    
    public func focusCamera(_ focusPoint: CGPoint) {
        
        do {
            try self.device.lockForConfiguration()
            self.device.focusPointOfInterest = focusPoint
            self.device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
            self.device.exposurePointOfInterest = focusPoint
            self.device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - PRIVATE
    
    func setupScannerWithProperties() {
        
        if self.session.canAddInput(self.input!) {
            self.session.addInput(self.input!)
        }
        self.session.addOutput(self.output)
        self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        self.setupScanner(self.setupOutputWithDefaultValues() as [AnyObject]?)
        self.setupPreviewLayer()
    }
    
    func setupOutputWithDefaultValues() -> [AVMetadataObject.ObjectType] {
        let metadata = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43,
                        AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128,
                        AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.qr];
        
        return metadata
    }
    
    func setupPreviewLayer() {
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.preview?.frame = self.view.bounds
        self.view.layer.addSublayer(self.preview!)
    }
    
    
    public func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
        for metadata in metadataObjects {
            
            let readableCode = metadata as? AVMetadataMachineReadableCodeObject
            guard   let value = readableCode?.stringValue,
                    let type = readableCode?.type
                else {return}
            
                self.delegate?.didSuccessfullyScan(value, tye: type.rawValue)
        }
    }
    
}
