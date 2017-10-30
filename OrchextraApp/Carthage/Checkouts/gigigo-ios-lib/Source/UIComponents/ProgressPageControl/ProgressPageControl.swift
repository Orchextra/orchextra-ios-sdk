//
//  ProgressPageControl.swift
//  OCM
//
//  Created by José Estela on 17/3/17.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit

/**
 Use it to create a page control with a ProgressDurationView in the current page.
 
 - Since 2.3.0
 */
@available(iOS 9.0, *)
@IBDesignable open class ProgressPageControl: UIView {
    
    // MARK: - Constants
    
    private let kStackViewSpacing = CGFloat(10)
    private let kPageControlHeight = CGFloat(5)
    private let kPageControlVideoWidth = CGFloat(45)
    
    // MARK: - Private attributes
    
    private var stackView: UIStackView?
    
    // MARK: - Public attributes
    
    /// To set the current page
    ///
    /// - Since: 2.3
    open var currentPage: Int = 0 {
        didSet {
            if self.currentPage > (self.numberOfPages - 1) {
                LogWarn("You cannot set the current page greater than numberOfPages")
                self.currentPage = self.numberOfPages - 1
            } else if self.currentPage < 0 {
                LogWarn("You cannot set the current page less than 0")
                self.currentPage = 0
            }
            self.setPageControlViews()
        }
    }
    
    /// The number of pages of the page control
    /// - Since: 2.3
    @IBInspectable open var numberOfPages: Int = 0 {
        didSet {
            self.setPageControlViews()
        }
    }
    
    /// The color of pages
    /// - Since: 2.3
    @IBInspectable open var pageColor: UIColor = .black {
        didSet {
            self.setPageControlViews()
        }
    }
    
    /// The color of selected page progress view
    /// - Since: 2.3
    @IBInspectable open var selectedColor: UIColor = .lightGray {
        didSet {
            self.setPageControlViews()
        }
    }
    
    // MARK: - Public methods
    
    /// Static method to create an instance of a ProgressPageControl.
    ///
    /// - Parameters:
    ///   - numberOfPages: The number of pages
    ///   - pageColor: The color of pages
    ///   - selectedColor: The selected page color
    /// - Returns: A ProgressPageControl object
    /// - Since: 2.3
    open class func pageControl(withPages numberOfPages: Int, color pageColor: UIColor = .lightGray, selectedColor: UIColor = .white) -> ProgressPageControl {
        let pageControl = ProgressPageControl()
        if numberOfPages > 0 {
            pageControl.numberOfPages = numberOfPages
            pageControl.pageColor = pageColor
            pageControl.selectedColor = selectedColor
            pageControl.initializeView()
        }
        return pageControl
    }
    
    /// Method to start the current page animation.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation
    ///   - to: The progress value (between 0.0 & 1.0). Default is 1.0
    ///   - fromZero: Defines if we want the animaton duration from zero point or from the current position. Default is true
    /// - Since: 2.3
    open func startCurrentPage(withDuration duration: TimeInterval, to: Float = 1.0, fromZero: Bool = true) {
        guard
            let stackView = self.stackView,
            stackView.arrangedSubviews.indices.contains(self.currentPage),
            let progress = stackView.arrangedSubviews[self.currentPage] as? ProgressDurationView
        else {
            return
        }
        progress.layoutIfNeeded()
        self.startPageAnimation(of: progress, withDuration: duration, to: to, fromZero: fromZero)
    }
    
    /// Method to pause the current page animation.
    /// - Since: 2.3
    open func pauseCurrentPage() {
        guard
            let stackView = self.stackView,
            stackView.arrangedSubviews.indices.contains(self.currentPage),
            let progress = stackView.arrangedSubviews[self.currentPage] as? ProgressDurationView
        else {
            return
        }
        self.pausePageAnimation(of: progress)
    }
    
    // MARK: - Private methods
    
    private func setPageControlViews() {
        if let stackView = self.stackView {
            for arrangedSubView in stackView.arrangedSubviews {
                self.stackView?.removeArrangedSubview(arrangedSubView)
            }
            for subView in stackView.subviews {
                subView.removeFromSuperview()
            }
        }
        for view in self.pageControlViews() {
            self.stackView?.addArrangedSubview(view)
        }
    }
    
    private func pageControlViews() -> [UIView] {
        var views: [UIView] = []
        if self.numberOfPages > 0 {
            for i in 0...(self.numberOfPages - 1) {
                if i == self.currentPage {
                    views.append(self.currentPageView())
                } else {
                    views.append(self.pageView())
                }
            }
            return views
        }
        return []
    }
    
    private func pageView() -> UIView {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: kPageControlHeight).isActive = true
        view.heightAnchor.constraint(equalToConstant: kPageControlHeight).isActive = true
        view.layer.cornerRadius = kPageControlHeight / 2
        view.backgroundColor = self.pageColor
        return view
    }
    
    private func currentPageView() -> ProgressDurationView {
        let view = ProgressDurationView()
        view.progress = 0.0
        view.widthAnchor.constraint(equalToConstant: kPageControlVideoWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: kPageControlHeight).isActive = true
        view.layer.cornerRadius = kPageControlHeight / 2
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.trackTintColor = self.pageColor
        view.progressTintColor = self.selectedColor
        return view
    }
    
    private func startPageAnimation(of progress: ProgressDurationView, withDuration duration: TimeInterval, to: Float, fromZero: Bool) {
        progress.animate(to: to, withDuration: duration, fromZero: fromZero)
    }
    
    private func pausePageAnimation(of progress: ProgressDurationView) {
        progress.pause()
    }
    
    private func initializeView() {
        if self.numberOfPages > 0 {
            self.stackView = UIStackView()
            #if TARGET_INTERFACE_BUILDER
                if let progress = self.stackView?.arrangedSubviews[0] as? ProgressDurationView {
                    progress.progress = 0.5
                }
            #endif
            self.stackView?.alignment = .center
            self.stackView?.axis = .horizontal
            self.stackView?.spacing = self.kStackViewSpacing
            if let stackView = self.stackView {
                stackView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(stackView)
                self.addConstraints([
                    NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                    ])
                self.setPageControlViews()
            }
        }
    }
        
    // MARK: - Override methods
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.initializeView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeView()
    }
}
