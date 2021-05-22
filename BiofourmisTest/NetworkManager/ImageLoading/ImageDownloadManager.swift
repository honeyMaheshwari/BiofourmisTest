//
//  ImageDownloadManager.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    
    private lazy var loadingQueue: OperationQueue = OperationQueue()
    private lazy var loadingOperations: [URL: ImageLoadOperation] = [:]
    
    private init() {
    }
    
    func loadImage(from url: URL, opeartion: ImageLoadOperation) {
        loadingQueue.addOperation(opeartion)
        loadingOperations[url] = opeartion
    }
    
    func removeOperation(url: URL) {
        loadingOperations.removeValue(forKey: url)
    }
    
}
