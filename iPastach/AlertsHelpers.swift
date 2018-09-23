//
//  AlertsHelpers.swift
//  iPastach
//
//  Created by Юрий Гринев on 01.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct AlertStruct {
    let title: String?
    let message: String?
    
    init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

class AlertsHelper: NSObject {

    static let shared = AlertsHelper()
    
    func alertOn(_ vc: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction] = [], completion: (() -> ())? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true, completion: completion)
    }
    
    func actionOn(_ vc: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction] = []) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func confirmOn(_ vc: UIViewController, item: AlertStruct, actions: [UIAlertAction] = []) -> Void {}

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
