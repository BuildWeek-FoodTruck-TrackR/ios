//
//  SignInViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    var userController: UserController?
    var firebaseController = FirebaseController()
    var selectedAccountType: SignUpType? {
        didSet {
            guard isViewLoaded else { return }
        }
    }
    var diner: Diner?

    // MARK: - Outlets
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
        let password = passwordTextField.text else { return }

        if let accountType = selectedAccountType {
            switch accountType {
            case .diner:
                userController?.sendTaskToServer(diner: diner ?? Diner())
            case .operatoR:
                userController?.fetchTasksFromServer()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
