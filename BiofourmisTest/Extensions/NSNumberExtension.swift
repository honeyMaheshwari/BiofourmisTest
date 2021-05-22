//
//  NSNumberExtension.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

extension NSNumber {
    
    var isBoolean: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
    
}
