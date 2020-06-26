//
//  LoginViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var showPassword: Bool = false
    var firebaseController = FirebaseController()
    var userController = UserController()

    // MARK: - Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    //        passwordField?.setup()
        }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        }
    }
