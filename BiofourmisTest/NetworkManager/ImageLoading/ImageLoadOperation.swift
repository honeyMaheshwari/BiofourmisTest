//
//  ImageLoadOperation.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class ImageLoadOperation: Operation, NetworkHttpClient {
    private var loadingCompleteHandler: ((UIImage?, URL) -> Void)?
    private var url: URL
    
    init(_ url: URL, loadingCompleteHandler: @escaping (UIImage?, URL) -> Void) {
        self.url = url
        self.loadingCompleteHandler = loadingCompleteHandler
    }
    
    override func main() {
        if isCancelled { return }
        callAPIWith(url, httpMethod: .get) { [weak self] response in
            guard let `self` = self else { return }
            if self.isCancelled { return }
            guard let data = response.data, let image = UIImage(data: data) else {
                self.loadingCompleteHandler?(nil, self.url)
                return
            }
            self.loadingCompleteHandler?(image, self.url)
        }
    }
}
