//
//  CustomLoaderView.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class CustomLoaderView: UIView, Threads {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor = .white, style: UIActivityIndicatorView.Style, color: UIColor) {
        self.init(frame: frame)
        contentView.backgroundColor = backgroundColor
        activityIndicatorView.style = style
        activityIndicatorView.color = color
    }
    
    func startLoading(completion: @escaping () -> Void) {
        runOnMainThread {
            self.activityIndicatorView.startAnimating()
            completion()
        }
    }
    
    func stopLoading(completion: @escaping () -> Void) {
        runOnMainThread {
            self.activityIndicatorView.stopAnimating()
            completion()
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        _ = Bundle.main.loadNibNamed(CustomLoaderView.nameOfClass, owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        contentView.clipsToBounds = true
    }

}
