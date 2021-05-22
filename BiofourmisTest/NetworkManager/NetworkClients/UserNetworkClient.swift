//
//  UserNetworkClient.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

class UserNetworkClient: NetworkClient {
    
    func fetchUsersList(with page: Int, completion: @escaping (Bool, UsersListResponse?, String?) -> Void) {
        performingAPICall = true
        performGetOperation(endPoint: .users, parameters: ["page": page], resultType: UsersListResponse.self) { [weak self] response in
            self?.performingAPICall = false
            switch response {
            case .success(let usersResponse, let success):
                completion(success, usersResponse, nil)
            case .failure(let apiError):
                completion(false, nil, apiError.message)
            }
        }
    }
    
}
