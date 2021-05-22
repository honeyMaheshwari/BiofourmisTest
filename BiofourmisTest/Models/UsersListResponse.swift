//
//  UsersListResponse.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

struct UsersListResponse: Decodable {
    let page, perPage, total, totalPages: Int
    let users: [User]
    let support: Support

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case users = "data"
        case support
    }
}
