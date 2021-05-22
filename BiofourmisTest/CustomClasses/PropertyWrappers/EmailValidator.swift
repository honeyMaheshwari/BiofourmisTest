//
//  EmailValidator.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

@propertyWrapper
struct EmailValidator {
    
    private var email: String?
    var errorMessage: String?
    
    var wrappedValue: String? {
        get {
            return email
        } set {
            if newValue.validate.isEmpty {
                email = nil
                errorMessage = "Please enter a valid email."
            } else {
                let isValid = isValidateEmail(newValue.validate)
                email = isValid ? newValue : nil
                errorMessage = isValid ? nil : "Please enter a valid email."
            }
        }
    }
    
    init() {
        email = nil
    }
    
    init(email: String) {
        self.email = email
    }
    
    private func isValidateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
