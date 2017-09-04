//
//  LogTableViewCell.swift
//  Orchextra
//
//  Created by Carlos Vicente on 2/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

@IBDesignable class LogTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBInspectable @IBOutlet weak var cellStackView: UIStackView!
    
    @IBInspectable @IBOutlet weak var firstView: UIView!
    @IBInspectable @IBOutlet weak var typeImageView: UIImageView!
    @IBInspectable @IBOutlet weak var firstLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var secondView: UIView!
    @IBInspectable @IBOutlet weak var secondLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var secondRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var thirdView: UIView!
    @IBInspectable @IBOutlet weak var thirdLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var thirdRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var fourthView: UIView!
    @IBInspectable @IBOutlet weak var fourthLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var fourthRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var fifthView: UIView!
    @IBInspectable @IBOutlet weak var fifthLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var fifthRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var sixthView: UIView!
    @IBInspectable @IBOutlet weak var sixthLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var sixthRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var seventhView: UIView!
    @IBInspectable @IBOutlet weak var seventhLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var seventhRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var eightthView: UIView!
    @IBInspectable @IBOutlet weak var eightthLeftLabel: UILabel!
    @IBInspectable @IBOutlet weak var eightthRightLabel: UILabel!
    
    @IBInspectable @IBOutlet weak var separatorContainerView: UIView!
    
    // MARK: - Binding
    func bindTriggerViewModel(_ model: TriggerViewModel) {
        let firstViewMustBeDisplayed = model.firstLabelText != nil
        let secondViewMustBeDisplayed = (model.secondLabelLeftText != nil || model.secondLabelRightText != nil)
        let thirdViewMustBeDisplayed = (model.thirdLabelLeftText != nil || model.thirdLabelRightText != nil)
        let fourthViewMustBeDisplayed = (model.fourthLabelLeftText != nil || model.fourthLabelRightText != nil)
        let fifthViewMustBeDisplayed = (model.fifthLabelLeftText != nil || model.fifthLabelRightText != nil)
        let sixthViewMustBeDisplayed = (model.sixthLabelLeftText != nil || model.sixthLabelRightText != nil)
        let seventhViewMustBeDisplayed = (model.seventhLabelLeftText != nil || model.seventhLabelRightText != nil)
        let eightthViewMustBeDisplayed = (model.eighthLabelLeftText != nil || model.eighthLabelRightText != nil)
        
        if let imageDataNotNil = model.imageData {
            self.typeImageView?.image = UIImage(data: imageDataNotNil)
        }
        
        if firstViewMustBeDisplayed {
            self.firstView.isHidden = false
            self.displayFirstViewInformation(firstLabel: model.firstLabelText)
        } else {
            self.firstView.isHidden = true
        }
        
        if secondViewMustBeDisplayed {
            self.secondView.isHidden = false
            self.displaySecondViewInformation(
                leftLabel: model.secondLabelLeftText,
                rightLabel: model.secondLabelRightText
            )
        } else {
            self.secondView.isHidden = true
        }
        
        if thirdViewMustBeDisplayed {
            self.thirdView.isHidden = false
            self.displayThirdViewInformation(
                leftLabel: model.thirdLabelLeftText,
                rightLabel: model.thirdLabelRightText
            )
        } else {
            self.thirdView.isHidden = true
        }
        
        if fourthViewMustBeDisplayed {
            self.fourthView.isHidden = false
            self.displayFourthViewInformation(
                leftLabel: model.fourthLabelLeftText,
                rightLabel: model.fourthLabelRightText
            )
        } else {
            self.fourthView.isHidden = true
        }
        
        if fifthViewMustBeDisplayed {
            self.fifthView.isHidden = false
            self.displayFifthViewInformation(
                leftLabel: model.fifthLabelLeftText,
                rightLabel: model.fifthLabelRightText
            )
        } else {
            self.fifthView.isHidden = true
        }
        
        if sixthViewMustBeDisplayed {
            self.sixthView.isHidden = false
            self.displaySixthViewInformation(
                leftLabel: model.sixthLabelLeftText,
                rightLabel: model.sixthLabelRightText
            )
        } else {
            self.sixthView.isHidden = true
        }
        
        if seventhViewMustBeDisplayed {
            self.seventhView.isHidden = false
            self.displaySeventhViewInformation(
                leftLabel: model.seventhLabelLeftText,
                rightLabel: model.seventhLabelRightText
            )
        } else {
            self.seventhView.isHidden = true
        }
        
        if eightthViewMustBeDisplayed {
            self.eightthView.isHidden = false
            self.displayEightthViewInformation(
                leftLabel: model.eighthLabelLeftText,
                rightLabel: model.eighthLabelRightText
            )
        } else {
            self.eightthView.isHidden = true
        }
    }
    
    // MARK: - FirstView
    func displayFirstViewInformation(firstLabel: String?) {
        guard let labelText = firstLabel else { return }
        
        self.firstLabel.text = labelText
    }
    
    // MARK: - SecondView
    func displaySecondViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
       self.secondLeftLabel.text = leftLabelNotNil
       self.secondRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - ThirdView
    func displayThirdViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.thirdLeftLabel.text = leftLabelNotNil
        self.thirdRightLabel.text = rightLabelNotNil
    }
    
     // MARK: - FourthView
    func displayFourthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.fourthLeftLabel.text = leftLabelNotNil
        self.fourthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - FifthView
    func displayFifthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.fifthLeftLabel.text = leftLabelNotNil
        self.fifthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - SixthView
    func displaySixthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.sixthLeftLabel.text = leftLabelNotNil
        self.sixthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - SeventhView
    func displaySeventhViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.seventhLeftLabel.text = leftLabelNotNil
        self.seventhRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - EightthView
    func displayEightthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.eightthLeftLabel.text = leftLabelNotNil
        self.eightthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "LogsTableViewCell"
    }
    
}
