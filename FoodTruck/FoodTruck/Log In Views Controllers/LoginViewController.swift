//
//  LoginViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

       var passwordField: PasswordField?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    //        passwordField?.setup()
            
        }
        
        @IBAction func passwordFieldChanged(_ sender: PasswordField) {
            print("Password: \(sender.password), Password Strength: \(sender.passwordStrength)")
        }

}
