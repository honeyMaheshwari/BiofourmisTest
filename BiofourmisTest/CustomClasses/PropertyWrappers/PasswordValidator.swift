//
//  PasswordValidator.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

@propertyWrapper
struct PasswordValidator {
    private var password: String?
    var errorMessage: String?
    
    var wrappedValue: String? {
        get {
            return password
        } set {
            let isValid = newValue.validate.count > 4
            password = isValid ? newValue : nil
            errorMessage = isValid ? nil : "Password length should be greater than 4."
        }
    }
    
    init() {
        password = nil
    }
    
    init(password: String) {
        self.password = password
    }
    
}
