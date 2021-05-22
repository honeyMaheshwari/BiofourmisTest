//
//  Threads.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

protocol Threads {
    func runOnMainThread(_ closure: @escaping () -> Void)
    func delay(_ delay: Double, closure: @escaping () -> Void)
}

extension Threads {
    
    func runOnMainThread(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
}
