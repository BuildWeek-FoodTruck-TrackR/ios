//
//  LoginViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    var showPassword: Bool = false
    var apiController: APIController?
    var loginType = LoginType.signUp

    // MARK: - Outlets
    @IBOutlet var logInTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
        override func viewDidLoad() {
            super.viewDidLoad()
                    signUpButton.backgroundColor = UIColor(hue: 190/360,
                                                           saturation: 70/100,
                                                           brightness: 80/100,
                                                           alpha: 1.0)
            signUpButton.tintColor = .white
            signUpButton.layer.cornerRadius = 8.0
        }

    @IBAction func signUpnButtonTapped(_ sender: UIButton) {
        guard let apiController = apiController else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = UserRep(username: username, password: password, identifier: UUID().uuidString)
            if loginType == .signUp {
                apiController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign up successful",
                                                                    message: "Please log in",
                                                                    preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok",
                                                            style: .default,
                                                            handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .logIn
                                self.logInTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signUpButton.setTitle("Log in", for: .normal)
                            })
                        }
                    }
                }
            } else {
                apiController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    @IBAction func signInTypeHasChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up",
                                  for: .normal)
        } else {
            loginType = .logIn
            signUpButton.setTitle("Log in",
                                  for: .normal)
        }
    }
}
