//
//  TriggerViewModelFactory.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

struct TriggerViewModel {
    let imageData: Data?
    let firstLabelText: String?
    let secondLabelLeftText: String?
    let secondLabelRightText: String?
    let thirdLabelLeftText: String?
    let thirdLabelRightText: String?
    let fourthLabelLeftText: String?
    let fourthLabelRightText: String?
    let fifthLabelLeftText: String?
    let fifthLabelRightText: String?
    let sixthLabelLeftText: String?
    let sixthLabelRightText: String?
    let seventhLabelLeftText: String?
    let seventhLabelRightText: String?
    let eighthLabelLeftText: String?
    let eighthLabelRightText: String?
}

class TriggerViewModelFactory {
    
    static func triggerViewModel(from triggerFired: TriggerFired) ->
        TriggerViewModel? {
        var triggerViewModel: TriggerViewModel? = nil
        let trigger = triggerFired.trigger
            
        switch trigger.triggerId {
        case "barcode":
           triggerViewModel = barCodeTriggerViewModel(from: triggerFired)
            break
        case "qr":
            triggerViewModel = qrTriggerViewModel(from: triggerFired)
            break
        case "beacon":
            triggerViewModel = beaconTriggerViewModel(from: triggerFired)
            break
        case "beacon_region":
            triggerViewModel = beaconRegionTriggerViewModel(from: triggerFired)
            break
        case "eddystone":
            triggerViewModel = eddystoneBeaconTriggerViewModel(from: triggerFired)
            break
        case "eddystone_region":
            triggerViewModel = eddystoneRegionTriggerViewModel(from: triggerFired)
            break
            
        case "geofence":
            triggerViewModel = geofenceTriggerViewModel(from: triggerFired)
            break
       
        case "vuforia":
            triggerViewModel = imageRecognitionTriggerViewModel(from: triggerFired)
            break
        default:
            triggerViewModel = nil
            break
        }
            
        return triggerViewModel
    }
    
    static func barCodeTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "barCode")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Barcode",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
    }
    
    static func qrTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "QR")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Qr",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
    }
    
    static func beaconTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "iBeacon")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "iBeacon",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)

    }
    
    static func beaconRegionTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "iBeacon_region")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "iBeacon region",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)

    }
    
    static func eddystoneBeaconTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "eddystone_beacon")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Eddystone",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
        
    }
    
    static func eddystoneRegionTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "eddystone_region")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Eddystone region",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
    }
    
    static func geofenceTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "geofences_trigger")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Geofence",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
    }
    
    static func imageRecognitionTriggerViewModel(from triggerFired: TriggerFired) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "image_recognition")
        let imageData = UIImagePNGRepresentation(image)
        let trigger = triggerFired.trigger
        let value = trigger.urlParams()["value"] as? String
        let timestamp = "\(triggerFired.date)"

        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Image recognition",
            secondLabelLeftText: "Timestamp: ",
            secondLabelRightText: timestamp,
            thirdLabelLeftText: nil,
            thirdLabelRightText: nil,
            fourthLabelLeftText: "Value: ",
            fourthLabelRightText: value,
            fifthLabelLeftText: nil,
            fifthLabelRightText: nil,
            sixthLabelLeftText: nil,
            sixthLabelRightText: nil,
            seventhLabelLeftText: nil,
            seventhLabelRightText: nil,
            eighthLabelLeftText: nil,
            eighthLabelRightText: nil)
    }
}
