//
//  DinerOrOperatorViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/19/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class DinerOrOperatorViewController: UIViewController {

    var apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            performSegue(withIdentifier: "LoginViewModalSegue",
                         sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.apiController = apiController
            }
        }
    }
}
