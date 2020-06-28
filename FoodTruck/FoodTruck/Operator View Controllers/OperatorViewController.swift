//
//  OperatorViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/20/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import UIKit

class OperatorViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var contactInfoTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var menuTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!

    // MARK: - Properties
    var truck: Truck? {
        didSet {
            updateViews()
        }
    }
    var apiController: APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    func updateViews() {
        guard isViewLoaded else { return }
        truck?.name = nameTextField.text
        truck?.cuisineType = typeTextField.text
        truck?.hrsOfOps = hoursTextField.text
        truck?.contactInfo = contactInfoTextField.text
        truck?.location = locationTextField.text
        truck?.menu = menuTextView.text
        title = truck?.name ?? "Create a truck"
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
            !name.isEmpty,
                       let cuisingType = typeTextField.text,
            !cuisingType.isEmpty,
                       let hrsOfOps = hoursTextField.text,
            !hrsOfOps.isEmpty,
                       let contactInfo = contactInfoTextField.text,
            !contactInfo.isEmpty,
                       let location = locationTextField.text,
            !location.isEmpty,
                       let menu = menuTextView.text,
            !menu.isEmpty else { return }

            let newTruck = Truck(cuisineType: cuisingType,
                                 name: name,
                                 hrsOfOps: hrsOfOps,
                                 contactInfo: contactInfo,
                                 location: location,
                                 menu: menu,
                                 identifier: UUID())
        apiController?.sendTruckToServer(truck: newTruck)
            print("Truck sent to server")
                       do {
                           try CoreDataStack.shared.mainContext.save()
                        print("Truck saved in core data")
                       } catch {
                           print("Error saving truck to moc: \(error)")
            }
            return
        }
    }
