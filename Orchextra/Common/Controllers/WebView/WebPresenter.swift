//
//  WebVCPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 28/8/17.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import Foundation

protocol PresenterProtocol {
    func viewDidLoad()
    func userDidTapReload()
    func userDidTapGoBack()
    func userDidTapGoForward()
    func userDidTapCancel()
}

class WebPresenter: PresenterProtocol {
    weak var webView: WebView?
    
    init(webView: WebView) {
        self.webView = webView
    }
    
    // MARK: Presenter protocol
    func viewDidLoad() {
        self.webView?.displayInformation()
    }
    
    func userDidTapReload() {
        self.webView?.reload()
    }
    
    func userDidTapGoBack() {
        self.webView?.goBack()
    }
    
    func userDidTapGoForward() {
        self.webView?.goForward()
    }
    
    func userDidTapCancel() {
        self.webView?.dismiss()
    }
}
