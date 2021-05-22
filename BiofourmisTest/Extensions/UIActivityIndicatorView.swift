//
//  UIActivityIndicatorView.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

extension UIActivityIndicatorView {
    
    static var largeLoaderStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .large
        } else {
            return .whiteLarge
        }
    }
    
    static var smallLoaderStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .medium
        } else {
            return .white
        }
    }
    
}
