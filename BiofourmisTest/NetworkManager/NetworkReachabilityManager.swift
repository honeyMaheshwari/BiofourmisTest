//
//  NetworkReachabilityManager.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit
import Reachability

class NetworkReachabilityManager: NSObject {
    
    static let shared: NetworkReachabilityManager = NetworkReachabilityManager()
    private let reachability: Reachability?
    
    private(set) var isRechable: Bool = false
    
    override private init() {
        reachability = try? Reachability()
        isRechable = reachability?.connection != .unavailable
    }
    
    func startMonitoringNetwork() {
        reachability?.whenReachable = { [weak self] _ in
            self?.isRechable = true
        }
        reachability?.whenUnreachable = { [weak self] _ in
            self?.isRechable = false
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopMonitoringNetwork() {
        reachability?.stopNotifier()
    }
    
}
