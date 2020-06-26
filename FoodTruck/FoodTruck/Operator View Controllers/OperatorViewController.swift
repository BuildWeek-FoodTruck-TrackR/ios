//
//  OperatorViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/20/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class OperatorViewController: UIViewController {

//    var userController: UserController?

    // MARK: - IBOutlets
     @IBOutlet var truckImageView: UIImageView!
     @IBOutlet var imageURLTextField: UITextField!
     @IBOutlet var truckNameTextField: UITextField!
     @IBOutlet var foodTypeTextField: UITextField!
     @IBOutlet var hoursTextField: UITextField!
     @IBOutlet var contactInfoTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


    // MARK: - IBAction
    @IBAction func setUpMenu(_ sender: UIButton) {
        let op = Operator(identifier: identifier, )
    }
}
