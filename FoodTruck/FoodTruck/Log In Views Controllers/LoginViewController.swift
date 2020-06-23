//
//  LoginViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var user: User? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    //        passwordField?.setup()
        }

    func updateViews() {
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
    }
}
