//
//  WebVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 28/8/17.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit
import WebKit
import GIGLibrary

protocol WebVCDelegate: class {
	func webViewDidScroll(_ scrollView: UIScrollView)
}

protocol WebView: class {
	func displayInformation()
	func reload()
	func goBack()
	func goForward()
    func dismiss()
}

class WebVC: UIViewController {
	var url: URL?
	weak var delegate: WebVCDelegate?
	var presenter: WebPresenter?
	
	fileprivate var webview = WKWebView()
	@IBOutlet weak fileprivate var webViewContainer: UIView!
	@IBOutlet weak var controlBar: UIToolbar!
	@IBOutlet weak fileprivate var buttonClose: UIBarButtonItem!
	
	// TOOLBAR
	@IBOutlet weak fileprivate var buttonBack: UIBarButtonItem!
	@IBOutlet weak fileprivate var buttonForward: UIBarButtonItem!
	@IBOutlet weak fileprivate var buttonReload: UIBarButtonItem!
	
	// MARK: - View LifeCycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.presenter?.viewDidLoad()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    
    deinit {
        // HOTFIX: Avoid iOS 9 crash of over-releasing weak references
        self.webview.scrollView.delegate = nil
    }
	
	// MARK: - UI Actions
	
	@IBAction func onButtonCancelTap(_ sender: UIBarButtonItem) {
		self.presenter?.userDidTapCancel()
	}
	
	@IBAction func onBackButtonTap(_ sender: UIBarButtonItem) {
		self.presenter?.userDidTapGoBack()
	}
	
	@IBAction func onForwardButtonTap(_ sender: UIBarButtonItem) {
		self.presenter?.userDidTapGoForward()
	}
	
	@IBAction func onReloadButtonTap(_ sender: UIBarButtonItem) {
		self.presenter?.userDidTapReload()
	}
	
	// MARK: - Private Helpers
	
	fileprivate func initializeView() {
		self.webview.scrollView.delegate = self
		self.webview.navigationDelegate = self
		
		self.webview.scrollView.bounces = true
		self.webViewContainer.addSubviewWithAutolayout(self.webview)
	}
	
	fileprivate func updateToolbar() {
		self.buttonBack.isEnabled = self.webview.canGoBack
		self.buttonForward.isEnabled = self.webview.canGoForward
	}
	
	fileprivate func addConstraints(view: UIView) -> UIView {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		let Hconstraint = NSLayoutConstraint(
			item: view,
            attribute: .width,
            relatedBy: .equal,
			toItem: nil,
            attribute: .notAnAttribute,
			multiplier: 1.0,
			constant: UIScreen.main.bounds.width
		)
		
		let Vconstraint = NSLayoutConstraint(
			item: view,
            attribute: .height,
            relatedBy: .equal,
			toItem: nil,
            attribute: .notAnAttribute,
			multiplier: 1.0,
			constant: self.view.frame.height
		)
		
		view.addConstraints([Hconstraint, Vconstraint])
		return view
	}
	
	fileprivate func loadRequest() {
        guard let url = self.url else { return }
        
		var request = URLRequest(url: url)
		request.addValue(Locale.currentLanguage(), forHTTPHeaderField: "Accept-Language")
		self.webview.load(request)
	}
}

extension WebVC: Instantiable {
    
    static var storyboard = "WebView"
    static var identifier = "WebVC"
}

extension WebVC: WebView {
    func displayInformation() {
        self.initializeView()
        self.loadRequest()
    }
    
    func reload() {
        self.webview.reload()
    }
    
    func goBack() {
        self.webview.goBack()
    }
    
    func goForward() {
        self.webview.goForward()
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension WebVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.webViewDidScroll(scrollView)
    }
}
