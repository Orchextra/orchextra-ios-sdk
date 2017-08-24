//
//  GIGScannerVC.swift
//  Orchextra
//
//  Created by Judith Medina on 23/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary
import AVFoundation


public protocol GIGScannerOutput {
    func didSuccessfullyScan(_ scannedValue: String, type: String)
}

public class GIGScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var scannerOutput: GIGScannerOutput?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var codeFrameView: UIView?
    var captureDevice: AVCaptureDevice!

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                                         AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                                         AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeQRCode]
            
            self.addPreviewLayer()
            
        } catch {
            LogWarn("Error initialize camera")
            return
        }
    }
    
    override public func didReceiveMemoryWarning() {
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
        
        try! self.captureDevice.lockForConfiguration()
        
        if self.captureDevice.hasTorch {
            
            if enable {
                self.captureDevice.torchMode = .on
            }
            else {
                self.captureDevice.torchMode = .off
            }
        }
        
        self.captureDevice.unlockForConfiguration()
    }
    
    public func focusCamera(_ focusPoint: CGPoint) {
        
        do {
            try self.captureDevice.lockForConfiguration()
            self.captureDevice.focusPointOfInterest = focusPoint
            self.captureDevice.focusMode = AVCaptureFocusMode.continuousAutoFocus
            self.captureDevice.exposurePointOfInterest = focusPoint
            self.captureDevice.exposureMode = AVCaptureExposureMode.continuousAutoExposure
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - PRIVATE
    
    private func addPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.frame = self.view.bounds
        guard let preview = self.previewLayer else {
            LogWarn("We couldn't add preview layer in the view")
            return }
        self.view.layer.addSublayer(preview)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        for metadata in metadataObjects {
            
            let readableCode = metadata as? AVMetadataMachineReadableCodeObject
            guard   let value = readableCode?.stringValue,
                let type = readableCode?.type
                else {return}
            
            self.scannerOutput?.didSuccessfullyScan(value, type: type)
        }
    }
}
