//
//  FoodTruckDetailViewController.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/22/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class FoodTruckDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var typelabel: UILabel!
    @IBOutlet var contactInfoLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var menuTextView: UITextView!
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var truckImageView: UIImageView!
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

    private func updateViews() {
        guard isViewLoaded else { return }
        typelabel.text = truck?.cuisineType
        contactInfoLabel.text = truck?.contactInfo
        locationLabel.text = truck?.location
        menuTextView.text = truck?.menu
        reviewTextView.text = truck?.truckReview
        truckImageView.image = UIImage(contentsOfFile: "food-truck-1")
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving truck to moc: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
}
