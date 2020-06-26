//
//  FirebaseController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/24/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum SignUpType {
    case diner
    case operatoR
}

class FirebaseController {
    let baseURL = URL(string: "https://foodtruck-71a6c.firebaseio.com/")!
    let diners: [Diner] = []
    let operators: [Operator] = []

    func firebaseRegisteredNewUser(email: String,
                                   password: String,
                                   signUpType: SignUpType) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("\(error)")
                strongSelf.showCreateAccount(email: email, password: password)
                return
            } else {
                print("Auth result: \(String(describing: authResult))")
            }
        }
    }

    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create account",
                                      message: "Would you like to create an account?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                                password: password,
                                                completion: { [weak self] authresult, error in
                                            guard self != nil else { return }
                                            guard error == nil else {
                                                print("\(String(describing: error))")
                                                return
                                                }
                                        })
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
        }))
        alert.present(alert, animated: true)
    }

    func firebaseLoginUser(email: String, password: String, signInAccountType: SignUpType) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error {
                print("\(error)")
            } else {
                print("Auth result: \(String(describing: authResult))")
            }
        }
    }
}
