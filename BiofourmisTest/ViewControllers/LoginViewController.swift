//
//  LoginViewController.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var loginButton: CustomButton!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateLoginButtonState()
    }
    
    // MARK: - Private Methods
    
    private func updateLoginButtonState() {
        loginButton.setButtonStatus(isEnable: viewModel.isValidData)
    }

    private func navigateToUsersList() {
        if let userController = UsersViewController.instantiate(with: .user) {
            runOnMainThread {
                self.navigationController?.setViewControllers([userController], animated: true)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction private func loginButtonTapped(_ sender: Any) {
        loginButton.startLoading()
        viewModel.performLogin { [weak self] success, message in
            self?.loginButton.stopLoading()
            if success {
                self?.navigateToUsersList()
            } else if let message = message {
                self?.displayErrorAlert(message: message)
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !loginButton.isLoading
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text else {
            return true
        }
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        switch textField {
        case emailTextField:
            return newString.count < 60
        default:
            return newString.count < 30
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            viewModel.email = emailTextField.text
            if !viewModel.isValidEmail {
                emailTextField.status = .error
            }
        default:
            viewModel.password = passwordTextField.text
            if !viewModel.isValidPassword {
                passwordTextField.status = .error
            }
        }
    }
    
    @IBAction private func textFieldEditingChange(_ textField: UITextField) {
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
        updateLoginButtonState()
    }
    
}
