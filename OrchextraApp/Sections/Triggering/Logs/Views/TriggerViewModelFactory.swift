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
    
    static func triggerViewModel(from trigger: Trigger) ->
        TriggerViewModel? {
        var triggerViewModel: TriggerViewModel? = nil
        switch trigger.triggerId {
        case "barcode":
           triggerViewModel = barCodeTriggerViewModel(from: trigger)
            break
        case "qr":
            triggerViewModel = qrTriggerViewModel(from: trigger)
            break
        case "beacon":
            triggerViewModel = beaconTriggerViewModel(from: trigger)
            break
        case "beacon_region":
            triggerViewModel = beaconRegionTriggerViewModel(from: trigger)
            break
        case "eddystone":
            triggerViewModel = eddystoneBeaconTriggerViewModel(from: trigger)
            break
        case "eddystone_region":
            triggerViewModel = eddystoneRegionTriggerViewModel(from: trigger)
            break
            
        case "geofence":
            triggerViewModel = geofenceTriggerViewModel(from: trigger)
            break
       
        case "vuforia":
            triggerViewModel = imageRecognitionTriggerViewModel(from: trigger)
            break
        default:
            triggerViewModel = nil
            break
        }
            
        return triggerViewModel
    }
    
    static func barCodeTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "barCode")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Barcode",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func qrTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "QR")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Qr",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func beaconTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "iBeacon")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "iBeacon",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func beaconRegionTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "iBeacon_region")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "iBeacon region",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func eddystoneBeaconTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "eddystone_beacon")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Eddystone",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func eddystoneRegionTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "eddystone_region")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Eddystone region",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func geofenceTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "geofences_trigger")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String
        
        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Geofence",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
    
    static func imageRecognitionTriggerViewModel(from trigger: Trigger) -> TriggerViewModel {
        let image = #imageLiteral(resourceName: "image_recognition")
        let imageData = UIImagePNGRepresentation(image)
        let value = trigger.urlParams()["value"] as? String

        return TriggerViewModel(
            imageData: imageData,
            firstLabelText: "Image recognition",
            secondLabelLeftText: "Timestamp",
            secondLabelRightText: "xx:xx",
            thirdLabelLeftText: "Type",
            thirdLabelRightText: trigger.triggerId,
            fourthLabelLeftText: "Value",
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
