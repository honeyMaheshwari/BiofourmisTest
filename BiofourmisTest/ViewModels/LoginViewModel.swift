//
//  LoginViewModel.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

final class LoginViewModel: NSObject {
    
    @EmailValidator var email: String?
    @PasswordValidator var password: String?
    
    var isValidEmail: Bool {
        email.validate.count > 0
    }
    
    var isValidPassword: Bool {
        password.validate.count > 0
    }
    
    var isValidData: Bool {
        isValidEmail && isValidPassword
    }
    
    var performingAPICall: Bool {
        client.performingAPICall
    }
    
    private let client = AuthenticationNetworkClient()
    
    func performLogin(completion: @escaping (Bool, String?) -> Void) {
        client.performLogin(with: email.validate, password: password.validate) { success, response, message in
            if success, let response = response {
                if response.isValidToken {
                    completion(success, message)
                } else {
                    completion(false, "Invalid Token")
                }
            } else {
                completion(success, message)
            }
        }
    }
    
}
