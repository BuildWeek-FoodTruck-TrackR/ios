//
//  TruckRepresentation.swift
//  FoodTruck
//
//  Created by Sammy Alvarado on 6/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    var cuisineType: String?
    var imageOfTruck: String?
    var customerRatings: Double
    var customerRatingAvg: Double
}
