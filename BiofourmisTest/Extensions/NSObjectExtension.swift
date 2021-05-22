//
//  NSObjectExtension.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        return String(describing: self)
    }
    
    var nameOfClass: String {
        return type(of: self).nameOfClass
    }
    
}
