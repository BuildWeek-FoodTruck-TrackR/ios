//
//  MenuRepresentation.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct MenuRepresentation: Codable {
    var itemPrice: Double
    var itemPhotos: String?
    var itemName: String?
    var itemDescription: String?
    var customerRatings: Double
    var customerRatingAvg: Double
}
