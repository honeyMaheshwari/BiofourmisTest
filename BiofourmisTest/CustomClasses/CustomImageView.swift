//
//  CustomImageView.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class CustomImageView: UIImageView {

    enum DownloadStatus {
        case downloading
        case downloaded
        case failed
        case none
    }
    
    private var downloadStatus: DownloadStatus = .none
    
    func setImage(from urlString: String, placeHolderImage: UIImage?) {
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            image = cachedImage
            return
        } else {
            image = placeHolderImage
        }
        
        guard let url = URL(string: urlString) else {
            downloadStatus = .failed
            return
        }
        
        if downloadStatus == .failed || downloadStatus == .downloading {
            return
        }
        downloadStatus = .downloading
        let operation = ImageLoadOperation(url) { [unowned self] image, url in
            ImageDownloadManager.shared.removeOperation(url: url)
            if let image = image {
                self.downloadStatus = .downloaded
                ImageCache.shared.save(image: image, forKey: urlString)
                self.image = image
            } else {
                self.downloadStatus = .failed
            }
        }
        ImageDownloadManager.shared.loadImage(from: url, opeartion: operation)
    }

}
