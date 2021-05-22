//
//  APIConstants.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation


enum APIResponse<T> {
    case success(T, Bool)
    case failure(APIError)
}

enum APIErrorType: Int {
    case invalidURL = 5001
    case invalidHeaderValue
    case noData
    case invalidJSON
    case invalidResponse
    case noNetwork
    case customAPIError
    
    func getMessage() -> String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidHeaderValue: return "Header value is not string"
        case .noData: return "No Data available"
        case .invalidJSON: return "Invalid JSON"
        case .invalidResponse: return "Invalid Response"
        case .noNetwork: return "Please check your internet connection."
        case .customAPIError: return ""
        }
    }
}

// MARK: - APIError

struct APIError {
    var message: String
    var type: APIErrorType
    var statusCode: Int
    var info: [String: Any]?
}

extension APIError {
    
    init(type: APIErrorType) {
        self.message = type.getMessage()
        self.type = type
        self.statusCode = type.rawValue
    }
    
    init(with error: Error?, statusCode: Int, info: [String: Any]? = nil) {
        self.message = error?.localizedDescription ?? ""
        self.type = .customAPIError
        self.statusCode = statusCode
        self.info = info
    }

}
