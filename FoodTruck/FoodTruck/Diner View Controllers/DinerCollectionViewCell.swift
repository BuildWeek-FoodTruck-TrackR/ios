//
//  DinerCollectionViewCell.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/20/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class DinerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var foodTruckNameLabel: UILabel!
    @IBOutlet var foodTruckImageView: UIImageView!
    @IBOutlet var foodTruckType: UILabel!
    @IBOutlet var foodTruckHours: UILabel!
    @IBOutlet var foodTruckContact: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
    }
    
}
