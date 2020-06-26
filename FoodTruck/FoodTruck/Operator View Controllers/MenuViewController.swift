//
//  MenuViewController.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/24/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var userController: UserController?

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var menuTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let image = foodImageView.image
        let menuText = menuTextView.text

//        let menu = Menu(image: image, menuText: menuTextView)
//        userController?.sendTaskToServer(menu: menu)
        

    }

}
