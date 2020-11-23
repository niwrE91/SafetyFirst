//
//  UiViewController+Alert.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 17.11.20.
//

import UIKit

extension UIViewController {
    /// Convinient method to show an alert view controller.
    /// - Parameters:
    ///   - title: `Optional` Title of UIAlertViewController
    ///   - message: Messate of UIAlertViewController
    ///   - actions: `Optional` UIAlertActions. If this array is empty a default `Ok` will be shown.
    func showAlert(with title: String?, message: String, and actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let actions = actions {
            actions.forEach(alertController.addAction)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }
}
