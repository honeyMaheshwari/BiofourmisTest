//
//  UsersViewController.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit
import MessageUI

class UsersViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    func initialSetup() {
        tableView.addPullToRefresh { [weak self] in
            self?.viewModel.resetData()
            self?.fetchUsersList(page: 1, isPullToRefrest: true)
        }
        tableView.displayDummyFooter()
        fetchUsersList(page: 1)
    }

    private func fetchUsersList(page: Int, isPullToRefrest: Bool = false) {
        page == 1 ? tableView.addLoaderOnBackground() : tableView.addLoaderOnFooter()
        viewModel.fetchUsersList(page: page) { [weak self] message in
            guard let `self` = self else { return }
            let removeCompletion: (() -> Void) = { [weak self] in
                self?.updateUIAccordingToResponse(message: message)
            }
            page == 1 ? self.tableView.removeLoaderFromBackground(completion: removeCompletion) : self.tableView.removeLoaderFromFooter(shouldAddDummyFooter: true, completion: removeCompletion)
        }
    }
    
    private func updateUIAccordingToResponse(message: String?) {
        runOnMainThread {
            self.tableView.endRefreshing()
            self.tableView.reloadData()
            self.viewModel.users.count == 0 ? self.tableView.displayNoDataView(with: message) : self.tableView.removeNoDataView()
        }
    }
    
    private func userDidTapOnEmail(_ email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailCompose = MFMailComposeViewController()
            mailCompose.setToRecipients([email])
            mailCompose.mailComposeDelegate = self
            runOnMainThread {
                self.present(mailCompose, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Button Actions

    @IBAction func logOutButtonTapped(_ sender: Any) {
        if let loginController = LoginViewController.instantiate(with: .main) {
            runOnMainThread {
                self.navigationController?.setViewControllers([loginController], animated: true)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.nameOfClass) as? UserTableViewCell else {
            return UITableViewCell()
        }
        if let user = viewModel.users[safe: indexPath.row] {
            cell.populateData(from: user) { [weak self] in
                self?.userDidTapOnEmail(user.email)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.isFetchInProgress, viewModel.isNextPageAvailable {
            let lastIndex = viewModel.users.count - 1
            let shouldFetch = indexPath.row == lastIndex
            if shouldFetch {
                fetchUsersList(page: viewModel.currentPage + 1)
            }
        }
    }
    
}


// MARK: - MFMailComposeViewControllerDelegate

extension UsersViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
