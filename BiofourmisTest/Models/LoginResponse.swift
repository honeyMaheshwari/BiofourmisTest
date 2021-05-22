//
//  LoginResponse.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

typealias AppToken = String

struct LoginResponse: Decodable {
    var token: AppToken
    
    var isValidToken: Bool {
        !token.isEmpty
    }
    
}
