//
//  AlertsHelpers.swift
//  iPastach
//
//  Created by Юрий Гринев on 01.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct AlertStruct {
    let title: String
    let message: String? = nil
}

class AlertsHelper: NSObject {
    
    // Singleton
    static let shared: AlertsHelper = AlertsHelper()
    
    func alertOn(_ vc: UIViewController, item: AlertStruct, actions: [UIAlertAction] = []) -> Void {
        let alertController = UIAlertController(title: item.title, message: item.message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true, completion: nil)
    }

    func confirmOn(_ vc: UIViewController, item: AlertStruct, actions: [UIAlertAction] = []) -> Void {}
    
    func actionOn(_ vc: UIViewController, item: AlertStruct, actions: [UIAlertAction] = []) -> Void {
        let alertController = UIAlertController(title: item.title, message: item.message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func shareOn(_ vc: UIViewController, items itemsToShare: [Any]) -> Void {
        let activityController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityController.excludedActivityTypes = [
            .airDrop,
            .mail,
            .copyToPasteboard,
            .message,
            .postToFacebook,
            .postToTwitter
        ]
        activityController.popoverPresentationController?.sourceView = vc.view
        
        vc.present(activityController, animated: true, completion: nil)
    }
}
