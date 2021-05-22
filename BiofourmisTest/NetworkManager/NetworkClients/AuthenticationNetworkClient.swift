//
//  AuthenticationNetworkClient.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class AuthenticationNetworkClient: NetworkClient {
    
    func performLogin(with email: String, password: String, completion: @escaping (Bool, LoginResponse?, String?) -> Void) {
        let parameters: [String: Any] = ["email": email, "password": password]
        performingAPICall = true
        performPostOperation(endPoint: .login, parameters: parameters, resultType: LoginResponse.self) { [weak self] response in
            self?.performingAPICall = false
            switch response {
            case .success(let loginResponse, let success):
                completion(success, loginResponse, nil)
            case .failure(let apiError):
                completion(false, nil, apiError.message)
            }
        }
    }
    
}
