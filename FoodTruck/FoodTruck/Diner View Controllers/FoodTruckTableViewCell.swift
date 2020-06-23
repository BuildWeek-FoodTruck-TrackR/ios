//
//  FoodTruckTableViewCell.swift
//  FoodTruck
//
//  Created by Kevin Stewart on 6/22/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class FoodTruckTableViewCell: UITableViewCell {

    @IBOutlet var foodTruckNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
