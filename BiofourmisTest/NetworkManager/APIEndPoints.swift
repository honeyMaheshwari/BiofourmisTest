//
//  APIEndPoints.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation


enum APIEndPoints: String {
    case login = "login"
    case users = "users"
    
    var path: String {
        return "https://reqres.in/api/" + rawValue
    }
    
}
