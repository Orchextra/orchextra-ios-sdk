//
//  LogTableViewCell.swift
//  Orchextra
//
//  Created by Carlos Vicente on 2/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

@IBDesignable class LogTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var cellStackView: UIStackView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondLeftLabel: UILabel!
    @IBOutlet weak var secondRightLabel: UILabel!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdLeftLabel: UILabel!
    @IBOutlet weak var thirdRightLabel: UILabel!
    
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthLeftLabel: UILabel!
    @IBOutlet weak var fourthRightLabel: UILabel!
    
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var fifthLeftLabel: UILabel!
    @IBOutlet weak var fifthRightLabel: UILabel!
    
    @IBOutlet weak var sixthView: UIView!
    @IBOutlet weak var sixthLeftLabel: UILabel!
    @IBOutlet weak var sixthRightLabel: UILabel!
    
    @IBOutlet weak var seventhView: UIView!
    @IBOutlet weak var seventhLeftLabel: UILabel!
    @IBOutlet weak var seventhRightLabel: UILabel!
    
    @IBOutlet weak var eightthView: UIView!
    @IBOutlet weak var eightthLeftLabel: UILabel!
    @IBOutlet weak var eightthRightLabel: UILabel!
    
    @IBOutlet weak var separatorContainerView: UIView!
    
    // MARK: - Binding
    func bindTriggerViewModel(_ model: TriggerViewModel) {
        if let imageDataNotNil = model.imageData {
            self.typeImageView?.image = UIImage(data: imageDataNotNil)
        }
        
        self.manageFirstView(with: model)
        self.manageSecondView(with: model)
        self.manageThirdView(with: model)
        self.manageFourthView(with: model)
        self.manageFifthView(with: model)
        self.manageSixthView(with: model)
        self.manageSeventhView(with: model)
        self.manageEightthView(with: model)
    }
    
    // MARK: - FirstView
    func manageFirstView(with model: TriggerViewModel) {
        let firstViewMustBeDisplayed = model.firstLabelText != nil
        if firstViewMustBeDisplayed {
            self.firstView.isHidden = false
            self.displayFirstViewInformation(firstLabel: model.firstLabelText)
        } else {
            self.firstView.isHidden = true
        }
    }
    
    func displayFirstViewInformation(firstLabel: String?) {
        guard let labelText = firstLabel else { return }
        
        self.firstLabel.text = labelText
    }
    
    // MARK: - SecondView
    func manageSecondView(with model: TriggerViewModel) {
        let secondViewMustBeDisplayed = (model.secondLabelLeftText != nil || model.secondLabelRightText != nil)
        if secondViewMustBeDisplayed {
            self.secondView.isHidden = false
            self.displaySecondViewInformation(leftLabel: model.secondLabelLeftText, rightLabel: model.secondLabelRightText)
        } else {
            self.secondView.isHidden = true
        }
    }
    
    func displaySecondViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
       self.secondLeftLabel.text = leftLabelNotNil
       self.secondRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - ThirdView
    func manageThirdView(with model: TriggerViewModel) {
        let thirdViewMustBeDisplayed = (model.thirdLabelLeftText != nil || model.thirdLabelRightText != nil)
        if thirdViewMustBeDisplayed {
            self.thirdView.isHidden = false
            self.displayThirdViewInformation(leftLabel: model.thirdLabelLeftText, rightLabel: model.thirdLabelRightText)
        } else {
            self.thirdView.isHidden = true
        }
    }
    
    func displayThirdViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.thirdLeftLabel.text = leftLabelNotNil
        self.thirdRightLabel.text = rightLabelNotNil
    }
    
     // MARK: - FourthView
    func manageFourthView(with model: TriggerViewModel) {
        let fourthViewMustBeDisplayed = (model.fourthLabelLeftText != nil || model.fourthLabelRightText != nil)
        if fourthViewMustBeDisplayed {
            self.fourthView.isHidden = false
            self.displayFourthViewInformation(leftLabel: model.fourthLabelLeftText, rightLabel: model.fourthLabelRightText)
        } else {
            self.fourthView.isHidden = true
        }
    }
    
    func displayFourthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.fourthLeftLabel.text = leftLabelNotNil
        self.fourthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - FifthView
    func manageFifthView(with model: TriggerViewModel) {
        let fifthViewMustBeDisplayed = (model.fifthLabelLeftText != nil || model.fifthLabelRightText != nil)
        if fifthViewMustBeDisplayed {
            self.fifthView.isHidden = false
            self.displayFifthViewInformation(leftLabel: model.fifthLabelLeftText, rightLabel: model.fifthLabelRightText)
        } else {
            self.fifthView.isHidden = true
        }
    }
    
    func displayFifthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.fifthLeftLabel.text = leftLabelNotNil
        self.fifthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - SixthView
    func manageSixthView(with model: TriggerViewModel) {
        let sixthViewMustBeDisplayed = (model.sixthLabelLeftText != nil || model.sixthLabelRightText != nil)
        if sixthViewMustBeDisplayed {
            self.sixthView.isHidden = false
            self.displaySixthViewInformation(leftLabel: model.sixthLabelLeftText, rightLabel: model.sixthLabelRightText)
        } else {
            self.sixthView.isHidden = true
        }
    }
    
    func displaySixthViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.sixthLeftLabel.text = leftLabelNotNil
        self.sixthRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - SeventhView
    func manageSeventhView(with model: TriggerViewModel) {
        let seventhViewMustBeDisplayed = (model.seventhLabelLeftText != nil || model.seventhLabelRightText != nil)
        if seventhViewMustBeDisplayed {
            self.seventhView.isHidden = false
            self.displaySeventhViewInformation(leftLabel: model.seventhLabelLeftText, rightLabel: model.seventhLabelRightText)
        } else {
            self.seventhView.isHidden = true
        }
    }
    
    func displaySeventhViewInformation(leftLabel: String?, rightLabel: String?) {
        guard let leftLabelNotNil = leftLabel,
            let rightLabelNotNil = rightLabel else { return }
        
        self.seventhLeftLabel.text = leftLabelNotNil
        self.seventhRightLabel.text = rightLabelNotNil
    }
    
    // MARK: - EightthView
    func manageEightthView(with model: TriggerViewModel) {
        let eightthViewMustBeDisplayed = (model.eighthLabelLeftText != nil || model.eighthLabelRightText != nil)
        if eightthViewMustBeDisplayed {
            self.eightthView.isHidden = false
            self.displayEightthViewInformation(leftLabel: model.eighthLabelLeftText, rightLabel: model.eighthLabelRightText)
        } else {
            self.eightthView.isHidden = true
        }
    }
    
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
