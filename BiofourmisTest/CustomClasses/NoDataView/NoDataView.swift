//
//  NoDataView.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class NoDataView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor = .white, message: String?) {
        self.init(frame: frame)
        contentView.backgroundColor = backgroundColor
        messageLabel.text = message ?? "Oops! Error occurred while fetching data from server."
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        _ = Bundle.main.loadNibNamed(NoDataView.nameOfClass, owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        contentView.clipsToBounds = true
    }

}
