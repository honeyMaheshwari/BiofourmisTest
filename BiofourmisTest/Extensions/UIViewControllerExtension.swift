//
//  UIViewControllerExtension.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

extension UIViewController: Threads {
    
    // MARK: - Alerts
    
    func displayAlert(with title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        runOnMainThread {
            self.present(alertController, animated: true)
        }
    }
    
    func displayErrorAlert(message: String? = nil) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        displayAlert(with: "Error", message: message, actions: [okAction])
    }
    
    class func instantiate(with storyboard: Storyboards, identifier: String? = nil) -> UIViewController? {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let controllerIdentifier = identifier ?? nameOfClass
        return uiStoryboard.instantiateViewController(withIdentifier: controllerIdentifier)
    }
    
}
