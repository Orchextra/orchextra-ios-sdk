//
//  SlideMenuVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


enum MenuState {
    case open
    case close
}


enum MenuDirection {
    case left
    case right
}


class SlideMenuVC: UIViewController, MenuTableDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    fileprivate let kPercentMenuOpeness: CGFloat = 0.8
    fileprivate let kVelocityThreshold: CGFloat = 500
    fileprivate let kAnimationDuration: TimeInterval = 0.4
    fileprivate let kAnimationDurationFast: TimeInterval = 0.2
    
    
    // MARK: - Public Properties
    var sections: [MenuSection] = [] {
        didSet {
            if let menuTableView = self.menuTableView {
                menuTableView.sections = sections
            }
        }
    }
	
	var statusBarStyle: UIStatusBarStyle = .default
    open var completion: (() -> Void)?
    
    
    // MARK: - Private Properties
    fileprivate var menuState = MenuState.close
    fileprivate var currentController: UIViewController?
    fileprivate weak var sectionControllerToShow: UIViewController?
	fileprivate var sectionIndexToShow: Int?
	fileprivate lazy var buttonClose = UIButton()
    weak fileprivate var menuTableView: SlideMenuTableVC?
    @IBOutlet weak fileprivate var customContentContainer: UIView!
    
    
    // Panning
    fileprivate var lastX: CGFloat = 0
    @IBOutlet fileprivate var panGesture: UIPanGestureRecognizer!
    
    
    class func menuVC() -> SlideMenuVC? {
        let menuVC = UIStoryboard.GIGInitialVC("SlideMenu") as? SlideMenuVC
        
        return menuVC
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.panGesture.delegate = self
        
        self.customContentContainer.addSubview(self.buttonClose)
        self.buttonClose.addTarget(self, action: #selector(closeMenuAnimated), for: .touchUpInside)
        self.buttonClose.isEnabled = false

        if let sectionController = self.sectionControllerToShow {
            self.setSection(sectionController, index: self.sectionIndexToShow ?? 0)
            self.sectionControllerToShow = nil
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setShadowOnContainer()
        self.buttonClose.frame = self.customContentContainer.frame
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let menuTableView = segue.destination as? SlideMenuTableVC , segue.identifier == "SlideMenuTableVC" else {
            return
        }
        
        self.menuTableView = menuTableView
        self.menuTableView?.sections = self.sections
        self.menuTableView?.menuTableDelegate = self
		
		if let index = self.sectionIndexToShow {
			self.menuTableView?.selectSection(index)
		}
    }
	
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return self.statusBarStyle
	}
    
    
    // MARK: - Public Methods
    
    func userDidTapMenuButton() {
        switch self.menuState {
            
        case .open:
            self.animate(closeMenu)
            
        case .close:
            self.animate(openMenu)
        }
        
        guard let completion = self.completion else {
            return
        }
        completion()
    }
    
    
	func setSection(_ viewController: UIViewController, index: Int) {
        guard self.customContentContainer != nil else {
            self.sectionControllerToShow = viewController
			self.sectionIndexToShow = index
            return
        }
        
        self.setViewController(viewController)
		
		guard self.menuTableView != nil else {
			self.sectionIndexToShow = index
			return
		}
		
		self.menuTableView?.selectSection(index)
    }
    
    
    // MARK: - Gesture
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let navigation = self.currentController as? UINavigationController
			, navigation.viewControllers.count > 1 else {
			return false
		}
		
		return true
	}
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        if let currentNavigation = self.currentController as? UINavigationController
            , currentNavigation.viewControllers.count > 1 { return }

        let translation = sender.translation(in: self.customContentContainer)

        switch sender.state {
        case .began:
            self.panGestureBegan()
        
        case .changed:
            self.panGestureStateChanged(translation)
            
        case .ended:
            self.panGestureEnded(sender)
            
        default:
            break
        }

    }
    
    fileprivate func panGestureBegan() {
        self.lastX = self.customContentContainer.x();
    }
    
    fileprivate func panGestureStateChanged(_ translation: CGPoint) {
        var newXPosition = self.lastX + translation.x
        
        // Check if position crossed the left bounds
        newXPosition = max(0, newXPosition)
        
        self.translateContent(min(newXPosition, self.view.width() * self.kPercentMenuOpeness))
    }
    
    fileprivate func panGestureEnded(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.customContentContainer)
        let currentXPos = self.customContentContainer.x()
        
        let direction = self.determineDirectoWithVelocity(velocity, position: currentXPos)
        
        switch direction {
        case .left:
            self.animateFast(closeMenu)
        
        case .right:
            self.animateFast(openMenu)
        }
        
        guard let completion = self.completion else {
            return
        }
        completion()
    }
    
    fileprivate func determineDirectoWithVelocity(_ velocity: CGPoint, position: CGFloat) -> MenuDirection {
        if velocity.x < -self.kVelocityThreshold {
            return .left
        }
        else if velocity.x > self.kVelocityThreshold {
            return .right
        }
        else {
            if position < ((self.view.width() * self.kPercentMenuOpeness) / 2) {
                return .left
            }
            else {
                return .right
            }
        }
    }
   
    
    // MARK: - MenuTableDelegate
    
	func tableDidSelecteSection(_ menuSection: MenuSection, index: Int) {
        
        guard let _ = menuSection.modeButtonType else {
            self.setSection(menuSection.sectionController, index: index)
            self.animate(closeMenu)
            guard  let completion = menuSection.completionButtonType else {
                LogWarn("completion Button Type nil!")
                return
            }
            completion()
            return
        }
        
        guard  let completion = menuSection.completionButtonType else {
            LogWarn("completion Button Type nil!")
            return
        }
        completion()
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func setShadowOnContainer() {
        let layer = self.customContentContainer.layer
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -5, height: 2)
        layer.shadowPath = UIBezierPath(rect: self.customContentContainer.bounds).cgPath
    }
    
    fileprivate func setViewController(_ viewController: UIViewController) {
		guard self.currentController != viewController else { return }
		
        self.addChildViewController(viewController)
        self.customContentContainer.addSubviewWithAutolayout(viewController.view)
        viewController.didMove(toParentViewController: self)
        self.customContentContainer.bringSubview(toFront: self.buttonClose)
		
		if let currentController = self.currentController {
			currentController.removeFromParentViewController()
			currentController.view.removeFromSuperview()
		}
		
		self.currentController = viewController
    }
    
    fileprivate func animateFast(_ code: @escaping () -> Void) {
        UIView.animate(withDuration: self.kAnimationDurationFast, animations: {
            code()
        }) 
    }
    
    fileprivate func animate(_ code: @escaping () -> Void) {
        UIView.animate(withDuration: self.kAnimationDuration, animations: {
            code()
        }) 
    }
    
    fileprivate func translateContent(_ xPos: CGFloat) {
        let tTranslate = CGAffineTransform(translationX: xPos, y: 0)
        self.customContentContainer.transform = CGAffineTransform.identity.concatenating(tTranslate)
    }
    
    fileprivate func openMenu() {
        self.menuState = .open
        self.buttonClose.isEnabled = true
        
        let xPos = self.view.width() - (self.view.width() * (1 - self.kPercentMenuOpeness))
        self.translateContent(xPos)
    }
    
    @objc func closeMenuAnimated() {
        self.animate(closeMenu)
    }
    
    fileprivate func closeMenu() {
        self.menuState = .close
        self.buttonClose.isEnabled = false
        
        self.translateContent(0)
    }

}
