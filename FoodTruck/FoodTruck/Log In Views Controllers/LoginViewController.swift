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

enum DinerOrOperator {
    case diner
    case operatoR
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    var showPassword: Bool = false
    var apiController = APIController()
    var loginType = LoginType.signUp
    var dinerOrOperator = DinerOrOperator.diner

    // MARK: - Outlets
    @IBOutlet var dinerOrOperatorSegmentedControl: UISegmentedControl!
    @IBOutlet var logInTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
        override func viewDidLoad() {
            super.viewDidLoad()
                    signUpButton.backgroundColor = UIColor(hue: 190/360,
                                                           saturation: 70/100,
                                                           brightness: 80/100,
                                                           alpha: 1.0)
            signUpButton.tintColor = .white
            signUpButton.layer.cornerRadius = 8.0
        }

    @IBAction func buttonTapped(_ sender: UIButton) {
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
                            print("Index is: \(self.dinerOrOperatorSegmentedControl.selectedSegmentIndex)")
                            if self.dinerOrOperatorSegmentedControl.selectedSegmentIndex == 0 {
                                self.performSegue(withIdentifier: "DinerSegue", sender: self)
                                return
                            } else {
                                self.performSegue(withIdentifier: "OperatorTableViewSegue", sender: self)
                                return
                            }
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
