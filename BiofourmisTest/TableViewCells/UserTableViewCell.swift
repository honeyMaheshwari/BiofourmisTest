//
//  UserTableViewCell.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImageView: CustomImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    
    private var didTapOnEmailLabel: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapOnEmailLabel(_:)))
        tapGesture.numberOfTapsRequired = 1
        userEmailLabel.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateData(from user: User, didTapOnEmailLabel: @escaping () -> Void) {
        self.didTapOnEmailLabel = didTapOnEmailLabel
        userNameLabel.text = user.fullName
        userEmailLabel.text = user.email
        userImageView.setImage(from: user.avatar, placeHolderImage: #imageLiteral(resourceName: "apple_logo"))
        /// The image loading code can show wrong image some times, I prefer SDWebImage for loading images
    }
    
    @objc
    private func userDidTapOnEmailLabel(_ sender: UITapGestureRecognizer) {
        didTapOnEmailLabel?()
    }
    
}
