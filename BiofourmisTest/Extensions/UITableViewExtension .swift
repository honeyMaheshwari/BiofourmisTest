//
//  UITableViewExtension .swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

extension UITableView: Threads {
    
    fileprivate var backgroundViewDisplayFrame: CGRect {
        let headerFrame: CGRect = tableHeaderView?.frame ?? .zero
        let frame: CGRect = CGRect(x: 0, y: headerFrame.height, width: bounds.width, height: bounds.height - headerFrame.height)
        return frame
    }
    
    // MARK: - Background View
    
    func addLoaderOnBackground() {
        runOnMainThread {
            let loader = CustomLoaderView(frame: self.backgroundViewDisplayFrame, style: UIActivityIndicatorView.largeLoaderStyle, color: .appThemeColor)
            self.backgroundView = loader
            loader.startLoading { }
        }
    }
    
    func removeLoaderFromBackground(completion: @escaping () -> Void) {
        if let loader = backgroundView as? CustomLoaderView {
            loader.stopLoading {
                self.backgroundView = nil
                completion()
            }
        } else {
            completion()
        }
    }
    
    func displayNoDataView(with message: String?) {
        let noDataView = NoDataView(frame: self.backgroundViewDisplayFrame, message: message)
        backgroundView = noDataView
    }
    
    func removeNoDataView() {
        if backgroundView is NoDataView {
            backgroundView = nil
        }
    }
    
    // MARK: - Footer View
    
    func addLoaderOnFooter() {
        runOnMainThread {
            let loader = CustomLoaderView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 50), style: UIActivityIndicatorView.smallLoaderStyle, color: .appThemeColor)
            self.tableFooterView = loader
            loader.startLoading { }
        }
    }
    
    func removeLoaderFromFooter(shouldAddDummyFooter status: Bool, completion: @escaping () -> Void) {
        if let loader = tableFooterView as? CustomLoaderView {
            loader.stopLoading {
                self.tableFooterView = status ? UIView() : nil
                completion()
            }
        } else {
            completion()
        }
    }
    
    func displayDummyFooter() {
        runOnMainThread {
            self.tableFooterView = UIView()
        }
    }
    
    // MARK: - Refresh Control
    
    var thRefreshControl: CustomRefreshControl? {
        refreshControl as? CustomRefreshControl
    }
    
    func endRefreshing() {
        runOnMainThread {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func addPullToRefresh(_ refreshingBegins: @escaping () -> Void) {
        if refreshControl == nil {
            runOnMainThread {
                let refreshControl = CustomRefreshControl(tintColor: UIColor.appThemeColor)
                refreshControl.refreshingBegins = refreshingBegins
                refreshControl.addTarget(self, action: #selector(self.pullToRefreshData(_:)), for: .valueChanged)
                self.refreshControl = refreshControl
            }
        }
    }
    
    @objc
    private func pullToRefreshData(_ refreshControl: CustomRefreshControl) {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            timer.invalidate()
            refreshControl.refreshingBegins?()
        }
    }
    
}
