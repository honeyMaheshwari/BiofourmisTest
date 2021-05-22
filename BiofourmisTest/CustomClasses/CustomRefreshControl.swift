//
//  CustomRefreshControl.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {

    var refreshingBegins: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.tintColor = tintColor
    }

}
