//
//  CustomButton.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class CustomButton: UIButton, Threads {

    private var loaderView: CustomLoaderView?
    
    var isLoading: Bool = false
    
    func setButtonStatus(isEnable: Bool) {
        runOnMainThread {
            self.isUserInteractionEnabled = isEnable
            self.backgroundColor = isEnable ? UIColor.appThemeColor : UIColor.appThemeColor.withAlphaComponent(0.4)
        }
    }
    
    func startLoading() {
        if isLoading {
            return
        }
        isLoading = true
        runOnMainThread {
            self.loaderView = CustomLoaderView(frame: self.bounds, backgroundColor: self.backgroundColor ?? .appThemeColor, style: UIActivityIndicatorView.smallLoaderStyle, color: .white)
            self.addSubview(self.loaderView!)
            self.loaderView?.startLoading { }
        }
    }
    
    func stopLoading() {
        if let loaderView = loaderView {
            runOnMainThread {
                loaderView.stopLoading {
                    loaderView.removeFromSuperview()
                    self.loaderView = nil
                }
            }
        }
        isLoading = false
    }

}
