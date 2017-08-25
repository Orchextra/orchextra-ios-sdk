//
//  ScannerPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol ScannerPresenterInput {
    func viewDidLoad()
    func userDidTapOrchextraScanner()
    func userDidTapCustomScanner()
    func userDidTapImageRecognition()
}

protocol ScannerUI: class {
    
}

struct ScannerPresenter {
    
    // MARK: - Public attributes
    
    weak var view: ScannerUI?
    let wireframe: ScannerWireframe
    
    // MARK: - Interactors
    
    let interactor: ScannerInteractorInput
}

extension ScannerPresenter: ScannerPresenterInput {
    func viewDidLoad() {
        
    }
    
    func userDidTapOrchextraScanner() {
        self.interactor.openOrchextraScanner()
    }
    
    func userDidTapCustomScanner() {
        self.interactor.openCustomScanner()
    }
    
    func userDidTapImageRecognition() {
        self.interactor.openImageRecognition()
    }
}
