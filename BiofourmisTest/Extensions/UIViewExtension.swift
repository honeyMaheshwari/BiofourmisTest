//
//  UIViewExtension.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        } set {
            layer.borderColor = newValue!.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        } set {
            self.layer.shadowColor = newValue!.cgColor
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
           return layer.shadowOpacity
       } set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        } set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            self.layer.shadowRadius = newValue
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    }
    
}

