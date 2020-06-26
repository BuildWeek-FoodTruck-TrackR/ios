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
    var truckRep: TruckRepresentation? {
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
        nameTextField.text = truckRep?.name
        typeTextField.text = truckRep?.cuisineType
        hoursTextField.text = truckRep?.hrsOfOps
        contactInfoTextField.text = truckRep?.contactInfo
        locationTextField.text = truckRep?.location
        menuTextView.text = truckRep?.menu
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
            !menu.isEmpty,
            let apiController = apiController else { return }
        
        let truck = Truck(cuisineType: cuisingType,
                          name: name,
                          hrsOfOps: hrsOfOps,
                          contactInfo: contactInfo,
                          location: location,
                          menu: menu)
        apiController.sendTruckToServer(truck: truck)

        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving truck to moc: \(error)")
        }
    }
}
