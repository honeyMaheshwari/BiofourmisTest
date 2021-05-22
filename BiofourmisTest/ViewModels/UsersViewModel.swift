//
//  UsersViewModel.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

final class UsersViewModel: NSObject {
    
    var users: [User] = []
    var currentPage = 1
    private var total = 0
    private var totalPages = 0
    var isFetchInProgress = false
    var isNextPageAvailable: Bool {
        currentPage < totalPages
    }
    
    let client = UserNetworkClient()
    
    func fetchUsersList(page: Int, completion: @escaping (String?) -> Void) {
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        client.fetchUsersList(with: page) { [weak self] success, usersListResponse, message in
            guard let `self` = self else { return }
            self.isFetchInProgress = false
            if success, let usersListResponse = usersListResponse {
                self.updateResponse(response: usersListResponse)
                completion(nil)
            } else {
                completion(message)
            }
        }
    }
    
    func updateResponse(response: UsersListResponse) {
        currentPage = response.page
        total = response.total
        totalPages = response.totalPages
        users += response.users
    }
    
    func resetData() {
        users.removeAll()
        currentPage = 1
        total = 0
        totalPages = 0
    }
    
}
