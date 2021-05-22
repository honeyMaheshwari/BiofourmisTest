//
//  AppSession.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

class AppSession: NSObject {

    static let shared = AppSession()
    private var appSession: URLSession!
    
    var session: URLSession {
        return appSession
    }
    
    override private init() {
        appSession = URLSession.shared
    }
    
}
