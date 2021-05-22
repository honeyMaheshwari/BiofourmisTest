//
//  User.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

struct User: Decodable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    var fullName: String {
        "\(firstName) \(lastName)".trimmed
    }
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
