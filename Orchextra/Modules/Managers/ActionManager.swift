//
//  ActionManager.swift
//  Orchextra
//
//  Created by Judith Medina on 31/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ActionManager {

    let pushManager: PushOrxInput
    let service: ActionServicesInput
    
    convenience init() {
        let pushManager = PushOrxManager.shared
        let service = ActionService()
        self.init(service: service, pushManager: pushManager)
    }
    
    init(service: ActionServicesInput, pushManager: PushOrxInput) {
        self.service = service
        self.pushManager = pushManager
    }
    
    func handler(action: Action) {
        LogDebug("Handler action: \(String(describing: action.type))")
        if action.notification != nil {
            self.prepareNotificationFor(action: action)
        } else {
            self.executeAndConfirm(action: action)
        }
    }
    
    // MARK: - PRIVATE
    
    private func executeAndConfirm(action: Action) {
        action.executable()
        self.service.confirmAction(action: action) { result in
            switch result {
            case .success: break
            case .error: break
            }
        }
    }

    private func prepareNotificationFor(action: Action) {
        switch UIApplication.shared.applicationState {
        case .active, .inactive:
            if action.schedule != nil {
                self.delayDeliveryNotification(action: action)
            } else {
                self.deliveryNotification(with: action)
            }
        case .background:
            self.delayDeliveryNotification(action: action)
        }
    }
    
    private func delayDeliveryNotification(action: Action) {
        LogDebug("action has been delay")
        self.pushManager.dispatchNotification(with: action)
    }
    
    private func deliveryNotification(with action: Action) {
        guard let notification = action.notification else {return}
        self.showAlertView(title: notification.title, body: notification.body, action: action)
    }
    
    private func showAlertView(title: String, body: String, action: Action) {
        let alert = Alert(title: title, message: body)
        alert.addCancelButton(OrchextraController.shared.strings.orxCancelButtonTitle, usingAction: nil)
        alert.addDefaultButton(OrchextraController.shared.strings.orxAcceptButtonTitle.uppercased()) { _ in
            self.executeAndConfirm(action: action)
        }
        alert.show()
    }
}
