//
//  StringExtension.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension Optional where Wrapped == String {
    
    var validate: String {
        self ?? ""
    }
}
