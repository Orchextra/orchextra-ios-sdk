//
//  ProgressDurationView.swift
//  GIGLibrary
//
//  Created by José Estela on 22/3/17.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import Foundation
import UIKit

/**
 Use it to create a ProgressView with the possibility to animate with a especific animation duration
 
 - Since: 2.3.0
 */
@IBDesignable open class ProgressDurationView: UIProgressView {
    
    // MARK: - Public methods
    
    /// Adjusts the current progress shown by the receiver.
    ///
    /// - Parameters:
    ///   - progress: The current progress shown by the receiver.
    ///   - duration: Duration of animation.
    ///   - fromZero: Defines if we want the animaton duration from zero point or from the current position. Default is true
    ///
    /// - Since: 2.3
    open func animate(to progress: Float, withDuration duration: TimeInterval, fromZero: Bool = true) {
        let animationDuration = !fromZero ? duration : abs(Double(progress - self.progress) * duration)
        self.progress = progress
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    /// Method to pause the current animation.
    ///
    /// - Since: 2.3
    open func pause() {
        var progressFrame: CGFloat = 0
        if self.subviews.indices.contains(1) {
            let subView = self.subviews[1]
            if let presentationFrame = subView.layer.presentation()?.frame {
                progressFrame = presentationFrame.size.width
            }
        }
        self.progress = Float(progressFrame / self.frame.size.width)
        UIView.animate(
            withDuration: 0.0,
            delay: 0.0,
            options: .beginFromCurrentState,
            animations: {
                self.layoutIfNeeded()
            },
            completion: nil
        )
        self.layer.removeAllAnimations()
        for eachView in self.subviews {
            eachView.layer.removeAllAnimations()
        }
    }
}
